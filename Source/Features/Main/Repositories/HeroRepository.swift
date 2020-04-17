//
//  HeroRepository.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

protocol HeroRepository {
	
	func store(heroes: [Hero]) -> Observable<[Hero]>
	
	func heroes(by role: HeroRole) -> Observable<[Hero]>
	
	func similarHeroes(from heroId: Int) -> Observable<[Hero]>
	
	func heroesFromApi() -> Observable<[Hero]>
	
	func heroesFromLocalStorage() -> Observable<[Hero]>
	
	func hero(with id: Int)  -> Observable<Hero>
	
	func isHeroesExistsInLocalStorage() -> Bool
	
}
