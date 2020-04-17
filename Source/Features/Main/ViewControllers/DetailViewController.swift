//
//  DetailViewController.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController : UIViewController {
	
	@IBOutlet private weak var heroImageView: UIImageView!
	@IBOutlet private weak var heroNameLabel: UILabel!
	@IBOutlet private weak var similarHeroesCollectionView: UICollectionView!
	
	private let disposeBag = DisposeBag()
	
	private let navigator: MainNavigator?
	private let viewModel: DetailViewModel?
	
	init(
		navigator: MainNavigator,
		viewModel: DetailViewModel
	) {
		
		self.navigator = navigator
		self.viewModel = viewModel
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Detail"
		
		configureCollectionView()
		
		bindViewModel()
		
		viewModel?.loadDetail()
		viewModel?.loadSimilarHeroes()
	}
	
	private func configureCollectionView() {
		
		let cellNib = UINib(nibName: HeroItemViewCell.cellIdentifier, bundle: nil)
		similarHeroesCollectionView.register(cellNib, forCellWithReuseIdentifier: HeroItemViewCell.cellIdentifier)
	}
	
	private func reloadCollectionView() {
		DispatchQueue.main.async { [weak self] in
			self?.similarHeroesCollectionView.reloadData()
		}
	}
	
	private func bindViewModel() {
		
		viewModel?.imageURLObservable
			.observeOn(MainScheduler.instance)
			.filter({ (imgEndpoint: MainEndpoint?) -> Bool in
				return imgEndpoint != nil
			})
			.map({ (endpoint: MainEndpoint?) -> MainEndpoint in
				return endpoint!
			})
			.subscribe(onNext: heroImageView.load)
			.disposed(by: disposeBag)
		
		viewModel?.nameObservable
			.observeOn(MainScheduler.instance)
			.bind(to: heroNameLabel.rx.text)
			.disposed(by: disposeBag)
		
		viewModel?.fetchSimilarHeroesSuccessObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: reloadCollectionView)
			.disposed(by: disposeBag)
		
		viewModel?.fetchSimilarHeroesFailedObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { (error: Error) in
				print("[TEST] Failed to load similar heroes")
			})
			.disposed(by: disposeBag)
	}
}

extension DetailViewController : UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		guard let heroesCount = viewModel?.similarHeroesCount else {
			return 0
		}
		
		return heroesCount
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroItemViewCell.cellIdentifier, for: indexPath) as? HeroItemViewCell,
			let heroItemViewModel = viewModel?.similarHeroItemViewModel(at: indexPath.row) else {
				return UICollectionViewCell()
		}
		
		cell.bind(viewModel: heroItemViewModel)
		
		return cell
	}
	
}

extension DetailViewController : UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if let heroId = viewModel?.similarHeroId(at: indexPath.row) {
			navigator?.navigationEvent?(.detail(id: heroId))
		}
	}
	
}
