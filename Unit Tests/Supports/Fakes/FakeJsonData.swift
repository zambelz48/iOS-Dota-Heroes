//
//  FakeJsonData.swift
//  Dota Heroes
//
//  Created by Nanda Julianda Akbar on 17/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

final class FakeJsonData {
	
	static let sampleJson: [[String: Any]] = [
		[
			"sampleKeyOne": "Sample value from key 1.1",
			"sampleKeyTwo": "Sample from key 1.2"
		],
		[
			"sampleKeyOne": "Sample value from key 2.1",
			"sampleKeyTwo": "Sample from key 2.2"
		]
	]
	
	private init() { }
	
}
