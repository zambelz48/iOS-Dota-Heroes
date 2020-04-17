//
//  HeroItemViewCell.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 17/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HeroItemViewCell: UICollectionViewCell {
	
	static let cellIdentifier = "HeroItemViewCell"
	
	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var heroNameLabel: UILabel!
	
	private let disposeBag = DisposeBag()
	
	func bind(viewModel: HeroItemViewModel) {
		
		viewModel.imageURLObservable
			.observeOn(MainScheduler.instance)
			.subscribe(
				onNext: { [weak self] (imgEndpoint: EndpointType?) in
				
					guard let validImgEndpoint = imgEndpoint else {
						self?.imageView.image = nil
						return
					}
					
					self?.imageView.load(from: validImgEndpoint)
				},
				onError: { [weak self] _ in
					self?.imageView.image = nil
				}
			)
			.disposed(by: disposeBag)
		
		viewModel.heroNameObservable
			.observeOn(MainScheduler.instance)
			.bind(to: heroNameLabel.rx.text)
			.disposed(by: disposeBag)
	}
	
}
