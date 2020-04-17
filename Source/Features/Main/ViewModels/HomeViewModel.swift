//
//  HomeViewModel.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewModel {
	
	var heroesCount: Int { get }
	
	var fetchHeroesSuccessObservable: Observable<Void> { get }
	
	var fetchHeroesFailedObservable: Observable<Error> { get }
	
	func heroId(at index: Int) -> Int
	
	func heroItemViewModel(at index: Int) -> HeroItemViewModel
	
	func fetchHeroes(by role: HeroRole)
	
}
