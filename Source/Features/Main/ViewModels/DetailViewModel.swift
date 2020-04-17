//
//  HomeDetailViewModel.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

protocol DetailViewModel {
	
	var imageURLObservable: Observable<MainEndpoint?> { get }
	
	var nameObservable: Observable<String> { get }
	
	var similarHeroesCount: Int { get }
	
	var fetchSimilarHeroesSuccessObservable: Observable<Void> { get }
	
	var fetchSimilarHeroesFailedObservable: Observable<Error> { get }
	
	func similarHeroId(at index: Int) -> Int
	
	func similarHeroItemViewModel(at index: Int) -> HeroItemViewModel
	
	func loadDetail()
	
	func loadSimilarHeroes()
	
}
