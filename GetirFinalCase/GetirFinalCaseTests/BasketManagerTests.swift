//
//  BasketManagerTests.swift
//  GetirFinalCaseTests
//
//  Created by Elif İlay KANDEMİR on 24.04.2024.
//

import XCTest
@testable import GetirFinalCase

final class BasketManagerTests: XCTestCase {
    
    var basketManager: BasketManager!
    
    override func setUp() {
        super.setUp()
        basketManager = BasketManager.shared
    }
    
    override func tearDown() {
        basketManager.clearBasket()
        super.tearDown()
    }
    
    func testAddProduct() {
        
        let product = Product( id: "001", name: "Test Product", price: 10.0, priceText: "10.0", imageURL: nil, thumbnailURL: nil, shortDescription: nil, category: nil, attribute: nil, unitPrice: nil, squareThumbnailURL: nil, status: nil, isExpanded: false, quantity: 1)
        let product2 = Product(id: "002", name: "Test Product 2", price: 15.0, priceText: "15.0", imageURL: nil, thumbnailURL: nil, shortDescription: nil, category: nil, attribute: nil, unitPrice: nil, squareThumbnailURL: nil, status: nil, isExpanded: false, quantity: 1)
        
        basketManager.addProduct(product)
        basketManager.addProduct(product2)
        
        XCTAssertEqual(basketManager.getAllProducts().count, 2, "Product count should be 1 after adding a product")
        XCTAssertEqual(basketManager.total, 25.0, "Total price should be 10.0 after adding a product")
    }
    
    func testRemoveProduct() {
        let product = Product( id: "001", name: "Test Product", price: 10.0, priceText: "10.0", imageURL: nil, thumbnailURL: nil, shortDescription: nil, category: nil, attribute: nil, unitPrice: nil, squareThumbnailURL: nil, status: nil, isExpanded: false, quantity: 1)
        let product2 = Product(id: "002", name: "Test Product 2", price: 15.0, priceText: "15.0", imageURL: nil, thumbnailURL: nil, shortDescription: nil, category: nil, attribute: nil, unitPrice: nil, squareThumbnailURL: nil, status: nil, isExpanded: false, quantity: 1)
        
        basketManager.addProduct(product)
        basketManager.addProduct(product2)
        
        basketManager.removeProduct(product)
        
        XCTAssertEqual(basketManager.getAllProducts().count, 1, "Product count should be 0 after removing a product")
        XCTAssertEqual(basketManager.total, 15.0, "Total price should be 0.0 after removing a product")
    }
    
    func testClearBasket() {
        
        let product = Product( id: "001", name: "Test Product", price: 10.0, priceText: "10.0", imageURL: nil, thumbnailURL: nil, shortDescription: nil, category: nil, attribute: nil, unitPrice: nil, squareThumbnailURL: nil, status: nil, isExpanded: false, quantity: 1)
        basketManager.addProduct(product)
        
        basketManager.clearBasket()
        
        XCTAssertEqual(basketManager.getAllProducts().count, 0, "Product count should be 0 after clearing the basket")
        XCTAssertEqual(basketManager.total, 0.0, "Total price should be 0.0 after clearing the basket")
    }
    
    func testTotalPriceNotification() {
        
        let expectation = self.expectation(description: "Expected the basketDidUpdate notification to be posted")
        var notificationUserInfo: [AnyHashable: Any]?
        
        let observer = NotificationCenter.default.addObserver(forName: .basketDidUpdate, object: nil, queue: nil) { notification in
            notificationUserInfo = notification.userInfo
            expectation.fulfill()
        }
        
        let product = Product( id: "001", name: "Test Product", price: 10.0, priceText: "10.0", imageURL: nil, thumbnailURL: nil, shortDescription: nil, category: nil, attribute: nil, unitPrice: nil, squareThumbnailURL: nil, status: nil, isExpanded: false, quantity: 1)
        
        basketManager.addProduct(product)
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(notificationUserInfo?["newPrice"] as? Double, 10.0, "The userInfo newPrice should be 10.0")
        
        NotificationCenter.default.removeObserver(observer)
    }
}


