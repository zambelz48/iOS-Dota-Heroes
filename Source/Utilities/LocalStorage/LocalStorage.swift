//
//  LocalStorage.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

protocol LocalStorage {
	
	func save<TargetType: Hashable & Codable>(
		key: String,
		data: TargetType,
		onSuccess: ((TargetType) -> ())?,
		onFailed: ((Error) -> ())?
	)
	
	func save<TargetType: Hashable & Codable>(
		key: String,
		data: [TargetType],
		onSuccess: (([TargetType]) -> ())?,
		onFailed: ((Error) -> ())?
	)
	
	func remove<TargetType: Hashable & Codable>(
		key: String,
		onSuccess: (TargetType) -> (),
		onFailed: ((Error) -> ())?
	)
	
	func single<TargetType: Hashable & Codable>(
		key: String,
		onSuccess: (TargetType) -> (),
		onFailed: ((Error) -> ())?
	)
	
	func list<TargetType: Hashable & Codable>(
		key: String,
		onSuccess: ([TargetType]) -> (),
		onFailed: ((Error) -> ())?
	)
	
	func isDataExists(_ key: String) -> Bool
	
}
