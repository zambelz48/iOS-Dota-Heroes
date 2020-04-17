//
//  Dota HeroNavigator.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

final class MainNavigator : Navigator {
	
	enum Event : NavigationEvent {
		case home
		case detail(id: Int)
		case showRoleSelection(view: UIView?)
		case closeRoleSelection
	}
	
	var navigationEvent: ((Event) -> ())?
	
}
