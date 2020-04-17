//
//  MockHttpResponse.swift
//  Dota Heroes
//
//  Created by Nanda Julianda Akbar on 17/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

final class MockHttpResponse {
	
	private init() {  }
	
	static func successfulURLSession() -> StubURLSession {
		return StubURLSession(statusCode: 200, fakeResponse: FakeJsonData.sampleJson)
	}
	
	static func failedURLSession() -> StubURLSession {
		return StubURLSession(statusCode: 400, fakeResponse: [])
	}
	
}
