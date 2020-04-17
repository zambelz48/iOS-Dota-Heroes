//
//  SimpleLocalStorage.swift
//  Sample Ecommerce
//
//  Created by Nanda Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

final class SimpleLocalStorage : LocalStorage {
	
	private let userDefaults = UserDefaults.standard
	
	private init() { }
	
	static let shared = SimpleLocalStorage()
	
	// MARK: - LocalStorage methods
	
	func save<TargetType: Hashable & Codable>(
		key: String,
		data: TargetType,
		onSuccess: ((TargetType) -> ())? = nil,
		onFailed: ((Error) -> ())?  = nil
	) {
		
		do {
			
			let encodedData = try encode(from: data)
			userDefaults.set(encodedData, forKey: key)
			
			onSuccess?(data)
		} catch let exception {
			onFailed?(exception)
		}
	}
	
	func save<TargetType: Hashable & Codable>(
		key: String,
		data: [TargetType],
		onSuccess: (([TargetType]) -> ())? = nil,
		onFailed: ((Error) -> ())?  = nil
	) {
		
		do {
			
			let encodedData = try encode(from: data)
			userDefaults.set(encodedData, forKey: key)
			
			onSuccess?(data)
		} catch let exception {
			onFailed?(exception)
		}
	}
	
	func remove<TargetType: Hashable & Codable>(
		key: String,
		onSuccess: (TargetType) -> (),
		onFailed: ((Error) -> ())?
	) {
		
	}
	
	func single<TargetType: Hashable & Codable>(
		key: String,
		onSuccess: (TargetType) -> (),
		onFailed: ((Error) -> ())? = nil
	) {
		do {
			let data: TargetType = try decode(key: key)
			onSuccess(data)
		} catch let exception {
			onFailed?(exception)
		}
	}
	
	func list<TargetType: Hashable & Codable>(
		key: String,
		onSuccess: ([TargetType]) -> (),
		onFailed: ((Error) -> ())?
	) {
		do {
			let data: [TargetType] = try decode(key: key)
			onSuccess(data)
		} catch let exception {
			onFailed?(exception)
		}
	}
	
	func isDataExists(_ key: String) -> Bool {
		return (userDefaults.string(forKey: key) != nil)
	}
	
	// MARK: - Private methods
	
	private func encode<T: Encodable>(from data: T) throws -> String {
		
		let encoder = JSONEncoder()
		
		do {
			
			let encodedData = try encoder.encode(data)
			let dataStr = String(decoding: encodedData, as: UTF8.self)
			
			return dataStr
		} catch let exception {
			throw exception
		}
		
	}
	
	private func decode<T: Decodable>(key: String) throws -> T {
		
		let decoder = JSONDecoder()
		
		do {
			
			guard let dataStr = userDefaults.string(forKey: key),
				let data = dataStr.data(using: .utf8) else {
					throw ErrorFactory.unknown
			}
			
			let decodedData = try decoder.decode(T.self, from: data)
			
			return decodedData
		} catch let exception {
			throw exception
		}
	}
	
}
