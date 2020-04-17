//
//  HomeDetailDefaultViewModel.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class DetailDefaultViewModel : DetailViewModel {
	
	var imageURLObservable: Observable<MainEndpoint?> {
		return imageURLRelay.asObservable()
	}
	var nameObservable: Observable<String> {
		return nameRelay.asObservable()
	}
	
	var similarHeroesCount: Int {
		return similarHeroItemViewModel.count
	}
	
	var fetchSimilarHeroesSuccessObservable: Observable<Void> {
		return fetchSimilarHeroesSuccessSubject.asObservable()
	}
	var fetchSimilarHeroesFailedObservable: Observable<Error> {
		return fetchSimilarHeroesFailedSubject.asObservable()
	}
	
	private var similarHeroItemViewModel = [HeroItemViewModel]()
	
	private let disposeBag = DisposeBag()
	
	private let imageURLRelay: BehaviorRelay<MainEndpoint?> = BehaviorRelay(value: nil)
	private let nameRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
	
	private let fetchSimilarHeroesSuccessSubject: PublishSubject<Void> = PublishSubject()
	private let fetchSimilarHeroesFailedSubject: PublishSubject<Error> = PublishSubject()
	
	private let heroId: Int
	private let heroRepository: HeroRepository
	
	init(
		heroId: Int,
		heroRepository: HeroRepository
	) {
		
		self.heroId = heroId
		self.heroRepository = heroRepository
		
	}
	
	func similarHeroId(at index: Int) -> Int {
		
		let hero = similarHeroItemViewModel[index]
		
		return hero.heroId
	}
	
	func similarHeroItemViewModel(at index: Int) -> HeroItemViewModel {
		return similarHeroItemViewModel[index]
	}
	
	func loadDetail() {
		
		heroRepository.hero(with: heroId)
			.subscribe(onNext: { [weak self] (hero: Hero) in
				self?.imageURLRelay.accept(MainEndpoint.heroImage(path: hero.img))
				self?.nameRelay.accept(hero.localizedName)
			})
			.disposed(by: disposeBag)
	}
	
	func loadSimilarHeroes() {
		
		heroRepository.similarHeroes(from: heroId)
			.subscribe(
				onNext: { [weak self] (heroes: [Hero]) in
					self?.configureItemViewModel(from: heroes)
					self?.fetchSimilarHeroesSuccessSubject.onNext(())
				},
				onError: fetchSimilarHeroesFailedSubject.onNext
			)
			.disposed(by: disposeBag)
	}
	
	private func configureItemViewModel(from heroes: [Hero]) {
		
		heroes.forEach { [weak self] (hero: Hero) in
			
			let heroItem = HeroItem(
				id: hero.id,
				imgURL: MainEndpoint.heroImage(path: hero.img),
				name: hero.localizedName
			)
			let itemViewModel = HeroItemDefaultViewModel(item: heroItem)
			
			self?.similarHeroItemViewModel.append(itemViewModel)
		}
	}
	
}
