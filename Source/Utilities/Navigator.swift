//
//  Navigator.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

protocol Navigator {
	
	associatedtype Event: NavigationEvent
	
	var navigationEvent: ((Event) -> ())? { get }
	
}

protocol NavigationEvent : Hashable {
	
	var hashedValue: String { get }
	
}

extension NavigationEvent {
	
	var hashedValue: String {
		return UUID().uuidString
	}
	
	func hash(into hasher: inout Hasher)  {
		hasher.combine(hashedValue)
	}
	
}
