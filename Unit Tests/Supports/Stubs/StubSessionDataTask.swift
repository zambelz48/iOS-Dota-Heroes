//
//  StubSessionDataTask.swift
//  Dota Heroes
//
//  Created by Nanda Julianda Akbar on 17/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

final class StubSessionDataTask : URLSessionDataTask {
	
	typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
	
	var mockResponse: Response
	let completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
	
	init(response: Response, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
		self.mockResponse = response
		self.completionHandler = completionHandler
	}
	
	override func resume() {
		completionHandler!(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
	}
	
}
