//
//  URLSessionStandard.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

protocol URLSessionStandard {
	
	func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
	
}

extension URLSession : URLSessionStandard {
	
	public static func defaultConfig() -> URLSession {
		let config = URLSessionConfiguration.default
		return URLSession(configuration: config)
	}
	
}
