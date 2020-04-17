//
//  HeroItemViewModel.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 17/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

protocol HeroItemViewModel {
	
	var heroId: Int { get }
	
	var imageURLObservable: Observable<EndpointType?> { get }
	
	var heroNameObservable: Observable<String> { get }
	
}
