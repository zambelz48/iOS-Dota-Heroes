//
//  HeroDefaultRepository.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

final class HeroDefaultRepository : HeroRepository {
	
	private let heroLocalStorageKey = "HeroLocalData"
	
	private let localStorage: LocalStorage
	private let httpHandler: HttpHandler
	
	init(
		localStorage: LocalStorage,
		httpHandler: HttpHandler
	) {
		
		self.localStorage = localStorage
		self.httpHandler = httpHandler
	}
	
	
	// MARK: - HeroRepository methods
	
	func store(heroes: [Hero]) -> Observable<[Hero]> {
		
		return Observable.create { [weak self] observer -> Disposable in
			
			let disposable = Disposables.create()
			guard let self = self else {
				observer.onError(ErrorFactory.unknown)
				observer.onCompleted()
				return disposable
			}
			
			self.localStorage.save(
				key: self.heroLocalStorageKey,
				data: heroes,
				onSuccess: { (savedHeroes: [Hero]) in
					observer.onNext(savedHeroes)
					observer.onCompleted()
				},
				onFailed: { (error: Error) in
					observer.onError(error)
					observer.onCompleted()
				}
			)
			
			return disposable
		}
	}
	
	func heroes(by role: HeroRole) -> Observable<[Hero]> {
		
		guard role != .All else {
			return heroesFromLocalStorage()
		}
		
		return heroesFromLocalStorage().flatMap { (heroes: [Hero]) -> Observable<[Hero]> in
			
			let filteredHeroes = heroes.filter { (hero: Hero) -> Bool in
				
				let roles = hero.roles.map { (role: String) -> String in
					return role.lowercased()
				}
				
				return roles.contains(role.rawValue.lowercased())
			}
			
			return .from(optional: filteredHeroes)
		}
	}
	
	func similarHeroes(from heroId: Int) -> Observable<[Hero]> {
		
		return hero(with: heroId).flatMap { [weak self] (hero: Hero) -> Observable<[Hero]> in
			
			guard let self = self,
				let heroAttribute = HeroAttribute(rawValue: hero.primaryAttr) else {
					return .error(ErrorFactory.unknown)
			}
			
			let similarHeroesObservable = self.heroesFromLocalStorage().flatMap { (heroes: [Hero]) -> Observable<[Hero]> in
				
				var filteredHeroes = heroes.filter { (hero: Hero) -> Bool in
					return hero.id != heroId && hero.primaryAttr == heroAttribute.rawValue
				}
				
				filteredHeroes.sort { (left: Hero, right: Hero) -> Bool in
					
					switch heroAttribute {
						
					case .agi:
						return left.moveSpeed > right.moveSpeed
						
					case .str:
						return left.baseAttackMax > right.baseAttackMax
						
					case .int:
						return left.baseMana > right.baseMana
						
					}
				}
				
				let topThreeSimilarHeroes = Array(filteredHeroes.prefix(3))
				
				return .from(optional: topThreeSimilarHeroes)
			}
			
			return similarHeroesObservable
		}
	}
	
	func heroesFromApi() -> Observable<[Hero]> {
		
		let endpoint: MainEndpoint = .heroStats
		let spec = HttpRequestSpec(url: endpoint, method: .get)
		
		return httpHandler.jsonRequestObservable(spec: spec)
	}
	
	func heroesFromLocalStorage() -> Observable<[Hero]> {
		
		return Observable.create { [weak self] observer -> Disposable in
			
			let disposable = Disposables.create()
			guard let self = self else {
				observer.onError(ErrorFactory.unknown)
				observer.onCompleted()
				return disposable
			}
			
			self.localStorage.list(
				key: self.heroLocalStorageKey,
				onSuccess: { (heroes: [Hero]) in
					observer.onNext(heroes)
					observer.onCompleted()
				},
				onFailed: { (error: Error) in
					observer.onError(error)
					observer.onCompleted()
				}
			)
			
			return disposable
		}
	}
	
	func hero(with id: Int) -> Observable<Hero> {
		
		var heroesSourceObservable: Observable<[Hero]>
		if (isHeroesExistsInLocalStorage()) {
			heroesSourceObservable = heroesFromLocalStorage()
		} else {
			heroesSourceObservable = heroesFromApi()
		}
		
		return heroesSourceObservable.flatMap { (heroes: [Hero]) -> Observable<Hero> in
			
			let filteredHeroes = heroes.filter { (hero: Hero) -> Bool in
				return hero.id == id
			}
			
			guard let hero = filteredHeroes.first else {
				return .error(ErrorFactory.unknown)
			}
			
			return .of(hero)
		}
	}
	
	func isHeroesExistsInLocalStorage() -> Bool {
		return localStorage.isDataExists(heroLocalStorageKey)
	}
}
