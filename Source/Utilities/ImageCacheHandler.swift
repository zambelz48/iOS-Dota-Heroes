//
//  ImageCacheHandler.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 17/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

final class ImageCacheHandler {
	
	static let shared = ImageCacheHandler()
	
	private let cache = NSCache<NSString, UIImage>()
	
	private init() {
		cache.totalCostLimit = initialTotalCostLimit()
	}
	
	func setCache(maxCapacity: Int) {
		cache.totalCostLimit = 1024 * 1024 * maxCapacity
	}
	
	func clearCachedImages() {
		cache.removeAllObjects()
	}
	
	func getCacheCapacity() -> Int {
		return cache.totalCostLimit
	}
	
	func storeToCache(with key: String, image: UIImage) {
		
		let cachedKey = NSString(string: key)
		
		cache.setObject(image, forKey: cachedKey)
	}
	
	func getCachedImage(for key: String) -> UIImage? {
		
		let cachedKey = NSString(string: key)
		guard let cachedImage = cache.object(forKey: cachedKey) else {
			return nil
		}
		
		return cachedImage
	}
	
	private func initialTotalCostLimit() -> Int {
		
		let physicalMemory = ProcessInfo.processInfo.physicalMemory
		let ratio = physicalMemory <= (1024 * 1024 * 512) ? 0.1 : 0.2
		let limit = physicalMemory / UInt64(1 / ratio)
		
		return limit > UInt64(Int.max) ? Int.max : Int(limit)
	}
	
}
