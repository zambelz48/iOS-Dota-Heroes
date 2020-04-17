//
//  AppUITests.swift
//  Dota Heroes
//
//  Created by Nanda Julianda Akbar on 17/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import XCTest

class AppUITests: XCTestCase {

	private var app: XCUIApplication!
	
    override func setUp() {
		super.setUp()
		
		app = XCUIApplication()
		
        continueAfterFailure = false
    }

    override func tearDown() {
		
		app = nil
		
		super.tearDown()
    }

    func testMainApp() {
		
		app.launch()
		
		// Tap show heroes selection view
		let heroesSelection = app.navigationBars.element(boundBy: 0)
		heroesSelection.tap()
		
		// Check whether heroes selection view exists
		let isHeroesSelectionViewExists = heroesSelection.waitForExistence(timeout: 2.0)
		XCTAssert(isHeroesSelectionViewExists)
		
		// Close heroes selection view
		let heroesSelectionViewCloseButton = app.buttons.element(boundBy: 1)
		heroesSelectionViewCloseButton.tap()
		
		// Tap collection view item to open detail view controller
		let collectionView = app.collectionViews.element
		collectionView.tap()
		
		// Check whether hero image exists in detail view controller
		let heroImage = app.images.element(boundBy: 0)
		let isHeroImageExists = heroImage.waitForExistence(timeout: 2.0)
		XCTAssert(isHeroImageExists)
		
		// Check whether similar heroes collection view exists in detail view controller
		let similarHeroesCollectionView = app.collectionViews.element
		let isSimilarHeroesCollectionViewExists = similarHeroesCollectionView.waitForExistence(timeout: 2.0)
		XCTAssert(isSimilarHeroesCollectionViewExists)
		
		// Tap navigation bar back button
		let navigationBackButton = app.navigationBars.buttons.element(boundBy: 0)
		navigationBackButton.tap()
		
		// Once back to the home view, check whether collection view exists
		let isCollectionExists = collectionView.waitForExistence(timeout: 5.0)
		XCTAssert(isCollectionExists)
    }

}
