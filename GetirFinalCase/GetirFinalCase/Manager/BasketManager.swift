//
//  BasketManager.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 16.04.2024.
//

import Foundation

final class BasketManager {
    static let shared = BasketManager()
    private init() {}
    
    
    private var products = [String: Product]()
    
    var total: Double {
        let totalValue = products.values.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        return totalValue
    }
    
    func addProduct(_ product: Product) {
        if products[product.id] != nil {
            products[product.id]?.quantity = product.quantity
        } else {
            products[product.id] = product
        }
        totalPrice()
        
    }
    
    func removeProduct(_ product: Product) {
        guard let existingProduct = products[product.id] else {
            return
        }
        if existingProduct.quantity > 0 {
            products[product.id]?.quantity = 0
        }
        products.removeValue(forKey: product.id)
        totalPrice()
    }
    
    func getAllProducts() -> [Product] {
        return Array(products.values)
    }
    
    func clearBasket() {
        products.removeAll()
        totalPrice()
    }
    
    private func totalPrice() {
        NotificationCenter.default.post(name: .basketDidUpdate, object: nil, userInfo: ["newPrice": total])
    }
}
