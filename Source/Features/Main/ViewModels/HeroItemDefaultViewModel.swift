//
//  HeroItemDefaultViewModel.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 17/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class HeroItemDefaultViewModel : HeroItemViewModel {
	
	var heroId: Int
	
	var imageURLObservable: Observable<EndpointType?> {
		return imageURLRelay.asObservable()
	}
	
	var heroNameObservable: Observable<String> {
		return heroNameRelay.asObservable()
	}
	
	private let imageURLRelay: BehaviorRelay<EndpointType?> = BehaviorRelay(value: nil)
	private let heroNameRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
	
	init(item: HeroItem) {
		
		heroId = item.id
		imageURLRelay.accept(item.imgURL)
		heroNameRelay.accept(item.name)
	}
	
}
