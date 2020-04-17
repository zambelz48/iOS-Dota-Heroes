//
//  AppRoutes.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

final class AppRoute {
	
	let navigationController: UINavigationController
	
	private let navigator: MainNavigator
	private let localStorage: LocalStorage
	private let httpHandler: HttpHandler
	
	init(
		navigationController: UINavigationController,
		navigator: MainNavigator,
		localStorage: LocalStorage,
		httpHandler: HttpHandler
	) {
		
		self.navigationController = navigationController
		self.navigator = navigator
		self.localStorage = localStorage
		self.httpHandler = httpHandler
		
		bindNavigationEvents()
	}
	
	func initialize() {
		navigator.navigationEvent?(.home)
	}
	
	private func bindNavigationEvents() {
		
		navigator.navigationEvent = { [weak self] (event: MainNavigator.Event) in
			
			guard let self = self else {
				return
			}
			
			switch event {
				
			case .home:
				
				let homeViewController = self.createHomeViewController()
				self.navigationController.setViewControllers([ homeViewController ], animated: false)
				
			case .detail(let id):
				
				let detailViewController = self.createDetailViewController(id: id)
				self.navigationController.pushViewController(detailViewController, animated: true)
				
			case .showRoleSelection(let customView):
				
				self.showHeroesSelection(with: customView)
				
			case .closeRoleSelection:
				
				self.closeHeroesSelectionView()
				
			}
			
		}
	}
	
	private func createHomeViewController() -> UIViewController {
		
		let heroRepository = HeroDefaultRepository(
			localStorage: localStorage,
			httpHandler: httpHandler
		)
		let homeViewModel = HomeDefaultViewModel(heroRepository: heroRepository)
		
		return HomeViewController(
			navigator: navigator,
			viewModel: homeViewModel
		)
	}
	
	private func createDetailViewController(id: Int) -> UIViewController {
		
		let heroRepository = HeroDefaultRepository(
			localStorage: localStorage,
			httpHandler: httpHandler
		)
		let detailViewModel = DetailDefaultViewModel(
			heroId: id,
			heroRepository: heroRepository
		)
		
		return DetailViewController(
			navigator: navigator,
			viewModel: detailViewModel
		)
	}
	
	private func showHeroesSelection(with customView: UIView?) {
		
		guard let topView = self.navigationController.viewControllers.first?.view else {
			return
		}
		
		let roleSelectionViewTag = CustomViewTag.heroSelectionView.rawValue
		let filteredViews = topView.subviews.filter { (view: UIView) -> Bool in
			return view.tag == roleSelectionViewTag
		}
		
		if let heroesSelectionView = customView as? HeroRolesView, (filteredViews.first == nil) {
			
			let overlayViewTag = CustomViewTag.overlayView.rawValue
			let overlayView = UIView(
				frame: CGRect(
					origin: topView.frame.origin,
					size: topView.frame.size
				)
			)
			overlayView.tag = overlayViewTag
			overlayView.alpha = 0.5
			overlayView.backgroundColor = .black
			
			topView.addSubview(overlayView)
			
			heroesSelectionView.show(at: topView)
		}
	}
	
	private func closeHeroesSelectionView() {
		
		guard let topView = self.navigationController.viewControllers.first?.view else {
			return
		}
		
		let roleSelectionViewTag = CustomViewTag.heroSelectionView.rawValue
		let parentSubViews = topView.subviews.filter { (view: UIView) -> Bool in
			return view.tag == roleSelectionViewTag
		}
		
		if let heroesSelectionView = parentSubViews.first as? HeroRolesView {
			heroesSelectionView.close {
				let overlayViewTag = CustomViewTag.overlayView.rawValue
				topView.viewWithTag(overlayViewTag)?.removeFromSuperview()
			}
		}
	}
	
}
