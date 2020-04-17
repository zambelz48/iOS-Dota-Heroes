//
//  HttpHandlerTests.swift
//  Dota Heroes
//
//  Created by Nanda Julianda Akbar on 17/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import XCTest
import RxSwift

enum SampleEndpoint : EndpointType {
	
	case someEndpoint
	
	var description: String {
		
		switch self {
		case .someEndpoint:
			return "http://fake-domain.com/fake-endpoint"
		}
		
	}
	
}

struct SampleJSON : Codable {
	
	let sampleKeyOne: String
	let sampleKeyTwo: String
	
}

struct DesiredData : Codable {
	
	let keyOne: String
	let keyTwo: String
	
}

struct SampleFoursquareJSON : Codable {
	
	let desiredData: DesiredData
	
}

class HttpHandlerTests: XCTestCase {

	private var disposeBag: DisposeBag!
	private var httpRequestSpec: HttpRequestSpec!
	private var httpHandler: HttpHandler!
	
    override func setUp() {
		super.setUp()
		
		disposeBag = DisposeBag()
		httpRequestSpec = HttpRequestSpec(url: SampleEndpoint.someEndpoint)
    }

    override func tearDown() {
		
		httpRequestSpec = nil
		httpHandler = nil
		disposeBag = nil
		
		super.tearDown()
    }
	
	func testBasicRequest() {
		
		let requestExpectation = expectation(description: "Expected the request getting called and success")
		
		httpHandler = HttpHandler(using: MockHttpResponse.successfulURLSession())
		httpHandler.request(spec: httpRequestSpec, onSuccess: { (data: Data?) in
			
			guard let validData = data else {
				XCTFail("data is nil")
				return
			}
			
			XCTAssert(!validData.isEmpty)
			
			requestExpectation.fulfill()
		})
		
		wait(for: [ requestExpectation ], timeout: 1.0)
	}
	
	func testBasicJsonRequest() {
		
		let requestExpectation = expectation(description: "Expected the request getting called and success")
		
		httpHandler = HttpHandler(using: MockHttpResponse.successfulURLSession())
		httpHandler.jsonRequest(spec: httpRequestSpec, onSuccess: { (response: [SampleJSON]?) in
			
			guard let validResponse = response else {
				XCTFail("Invalid response")
				return
			}
			
			XCTAssert(validResponse.count == FakeJsonData.sampleJson.count)
			
			requestExpectation.fulfill()
		})
		
		wait(for: [ requestExpectation ], timeout: 1.0)
	}
	
	func testBasicJsonRequestObservable() {
		
		let requestExpectation = expectation(description: "Expected the request getting called and success")
		
		httpHandler = HttpHandler(using: MockHttpResponse.successfulURLSession())
		httpHandler.jsonRequestObservable(spec: httpRequestSpec)
			.subscribe(onNext: { (listData: [SampleJSON]) in
				
				for i in 0..<listData.count {
					
					let data = listData[i]
					let expectedObject = FakeJsonData.sampleJson[i]
					
					guard let expectedSampleKeyOne = expectedObject["sampleKeyOne"] as? String else {
						XCTFail("Invalid data type")
						break
					}
					
					guard let expectedSampleKeyTwo = expectedObject["sampleKeyTwo"] as? String else {
						XCTFail("Invalid data type")
						break
					}
					
					XCTAssert(data.sampleKeyOne == expectedSampleKeyOne)
					XCTAssert(data.sampleKeyTwo == expectedSampleKeyTwo)
				}
				
				requestExpectation.fulfill()
			})
			.disposed(by: disposeBag)
		
		wait(for: [ requestExpectation ], timeout: 1.0)
	}

}
