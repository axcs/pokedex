//
//  PokedexUITests.swift
//  PokedexUITests
//
//  Created by axavierc on 21/06/2022.
//

import XCTest

class PokedexUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInfinitScroll() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let collectionViewsQuery = app.collectionViews
        let element = collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element
        element.swipeUp()
        
        let element2 = collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element
        element2.swipeUp()
        
        let verticalScrollBar5PagesCollectionView = app/*@START_MENU_TOKEN@*/.collectionViews.containing(.other, identifier:"Vertical scroll bar, 5 pages").element/*[[".collectionViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".collectionViews.containing(.other, identifier:\"Vertical scroll bar, 5 pages\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        verticalScrollBar5PagesCollectionView.swipeUp()
        element2.swipeUp()
        verticalScrollBar5PagesCollectionView.swipeUp()
        let verticalScrollBar10PagesCollectionView = app/*@START_MENU_TOKEN@*/.collectionViews.containing(.other, identifier:"Vertical scroll bar, 10 pages").element/*[[".collectionViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".collectionViews.containing(.other, identifier:\"Vertical scroll bar, 10 pages\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        verticalScrollBar10PagesCollectionView.swipeUp()
        verticalScrollBar10PagesCollectionView.swipeUp()
        element.swipeUp()
    }
    
    func testClickDetailsAndClose() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.collectionViews.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element(boundBy: 0).tap()
        let closeButton = app.buttons["close"]
        closeButton.tap()
    }
    
    
    func testClickFavorite() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).buttons["love"].tap()
        app.buttons["Ok"].tap()

 
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
