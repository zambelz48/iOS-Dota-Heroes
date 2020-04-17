//
//  HomeDefaultViewModel.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class HomeDefaultViewModel : HomeViewModel {
	
	var fetchHeroesSuccessObservable: Observable<Void> {
		return fetchHeroesSuccessSubject.asObservable()
	}
	var fetchHeroesFailedObservable: Observable<Error> {
		return fetchHeroesFailedSubject.asObservable()
	}
	
	var heroesCount: Int {
		return heroItemViewModels.count
	}
	
	private var heroItemViewModels: [HeroItemViewModel] = [HeroItemViewModel]()
	
	private let disposeBag = DisposeBag()
	private let heroesRelay: BehaviorRelay<[Hero]> = BehaviorRelay(value: [Hero]())
	private let fetchHeroesSuccessSubject: PublishSubject<Void> = PublishSubject()
	private let fetchHeroesFailedSubject: PublishSubject<Error> = PublishSubject()
	
	private let heroRepository: HeroRepository
	
	init(heroRepository: HeroRepository) {
		
		self.heroRepository = heroRepository
		
		heroesRelay.skip(1)
			.asObservable()
			.subscribe(
				onNext: { [weak self] (heroes: [Hero]) in
					self?.configure(heroes: heroes)
					self?.fetchHeroesSuccessSubject.onNext(())
				},
				onError: { [weak self] (error: Error) in
					self?.fetchHeroesFailedSubject.onNext(error)
				}
			)
			.disposed(by: disposeBag)
	}
	
	func heroId(at index: Int) -> Int {
		
		let itemViewModel = heroItemViewModels[index]
		
		return itemViewModel.heroId
	}
	
	func heroItemViewModel(at index: Int) -> HeroItemViewModel {
		return heroItemViewModels[index]
	}
	
	func fetchHeroes(by role: HeroRole) {
		
		guard !heroRepository.isHeroesExistsInLocalStorage() else {
			
			heroRepository.heroesFromApi()
				.bind(to: heroesRelay)
				.disposed(by: disposeBag)
			
			heroRepository.heroes(by: role)
				.bind(to: heroesRelay)
				.disposed(by: disposeBag)
			
			return
		}
		
		heroRepository.heroesFromApi()
			.flatMap({ [weak self] (heroes: [Hero]) -> Observable<[Hero]> in
				
				guard let self = self else {
					return .error(ErrorFactory.unknown)
				}
				
				return self.heroRepository.store(heroes: heroes)
			})
			.bind(to: heroesRelay)
			.disposed(by: disposeBag)
	}
	
	private func configure(heroes: [Hero]) {
		
		if (heroItemViewModels.count  > 0)  {
			heroItemViewModels.removeAll()
		}
		
		heroes.forEach { [weak self] (hero: Hero) in
			
			let heroItem = HeroItem(
				id: hero.id,
				imgURL: MainEndpoint.heroImage(path: hero.img),
				name: hero.localizedName
			)
			let itemViewModel = HeroItemDefaultViewModel(item: heroItem)
			
			self?.heroItemViewModels.append(itemViewModel)
		}
	}
	
}
