//
//  AppDelegate.swift
//  Dota Hero
//
//  Created by Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	private let navigator: MainNavigator = MainNavigator()
	private let localStorage: LocalStorage = SimpleLocalStorage.shared
	private let httpHandler: HttpHandler = HttpHandler()
	
	private var appRoute: AppRoute?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		
		ImageCacheHandler.shared.setCache(maxCapacity: 50)
		
		window = UIWindow()
		window?.rootViewController = rootViewController()
		window?.makeKeyAndVisible()
		
		return true
	}
	
	private func rootViewController() -> UINavigationController? {
		
		let navigationController = UINavigationController()
		
		appRoute = AppRoute(
			navigationController: navigationController,
			navigator: navigator,
			localStorage: localStorage,
			httpHandler: httpHandler
		)
		
		appRoute?.initialize()
		
		return appRoute?.navigationController
	}
	
}
