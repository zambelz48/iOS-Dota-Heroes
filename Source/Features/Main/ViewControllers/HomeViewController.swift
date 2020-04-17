//
//  HomeViewController.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit
import  RxSwift

final class HomeViewController : UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	private let heroRolesView: HeroRolesView? = .fromNib()
	
	private let disposeBag = DisposeBag()
	
	private let navigator: MainNavigator?
	private let viewModel: HomeViewModel?
	
	init(
		navigator: MainNavigator,
		viewModel: HomeViewModel
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
		
		setNavigationButton(HeroRole.All)
		configureCollectionView()
		
		bindRoleSection()
		bindViewModel()
		
		viewModel?.fetchHeroes(by: .All)
	}
	
	private func bindRoleSection() {
		
		heroRolesView?.onRoleSelection = { [weak self] (selectedRole: HeroRole?) in
			
			guard let self = self else {
				return
			}
			
			if let selectedRole = selectedRole {
				self.setNavigationButton(selectedRole)
				self.viewModel?.fetchHeroes(by: selectedRole)
			}
			
			self.navigator?.navigationEvent?(.closeRoleSelection)
		}
	}
	
	private func setNavigationButton(_ selectedHeroRole: HeroRole) {
		
		let button = UIButton(type: .custom)
		button.setTitle("Filter: \(selectedHeroRole.rawValue)", for: .normal)
		button.setImage(UIImage(named: "DropDown"), for: .normal)
		button.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
		button.backgroundColor = .none
		button.tintColor = .darkGray
		button.setTitleColor(.darkGray, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
		button.layer.cornerRadius = 8.0
		button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
		
		navigationItem.titleView = button
	}
	
	private func configureCollectionView() {
		
		let cellNib = UINib(nibName: HeroItemViewCell.cellIdentifier, bundle: nil)
		collectionView.register(cellNib, forCellWithReuseIdentifier: HeroItemViewCell.cellIdentifier)
	}
	
	private func reloadCollectionView() {
		DispatchQueue.main.async { [weak self] in
			self?.collectionView.setContentOffset(.zero, animated: true)
			self?.collectionView.reloadData()
		}
	}
	
	private func bindViewModel() {
		
		viewModel?.fetchHeroesSuccessObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: reloadCollectionView)
			.disposed(by: disposeBag)
		
		viewModel?.fetchHeroesFailedObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { (error: Error) in
				print("[TEST] Error: \(error.localizedDescription)")
			})
			.disposed(by: disposeBag)
	}
	
	@objc private func showAlert(_ sender: Any) {
		navigator?.navigationEvent?(.showRoleSelection(view: heroRolesView))
	}
	
}

extension HomeViewController : UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		guard let heroesCount = viewModel?.heroesCount else {
			return 0
		}
		
		return heroesCount
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroItemViewCell.cellIdentifier, for: indexPath) as? HeroItemViewCell,
			let heroItemViewModel = viewModel?.heroItemViewModel(at: indexPath.row) else {
				return UICollectionViewCell()
		}
		
		cell.bind(viewModel: heroItemViewModel)
		
		return cell
	}
	
}

extension HomeViewController : UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if let heroId = viewModel?.heroId(at: indexPath.row) {
			navigator?.navigationEvent?(.detail(id: heroId))
		}
	}
	
}
