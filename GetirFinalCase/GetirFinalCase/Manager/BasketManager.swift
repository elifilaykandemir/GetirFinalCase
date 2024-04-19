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
        print("Total value recalculated: \(totalValue)")
        return totalValue
    }
    
    func addProduct(_ product: Product) {
        if let existingProduct = products[product.id] {
            products[product.id]?.quantity = product.quantity
        } else {
            products[product.id] = product
        }
        calculateTotalPrice()
    }
    
    func removeProduct(_ product: Product) {
        if let existingProduct = products[product.id], existingProduct.quantity > product.quantity {
            products[product.id]?.quantity = product.quantity
        } else {
            products.removeValue(forKey: product.id)
        }
        calculateTotalPrice()
    }
    
    func updateProduct(_ updatedProduct: Product) {
            if let _ = products[updatedProduct.id] {
                products[updatedProduct.id] = updatedProduct
            } else {
                products[updatedProduct.id] = updatedProduct
            }
            calculateTotalPrice()
        }
    
    private func calculateTotalPrice() {
        NotificationCenter.default.post(name: .basketDidUpdate, object: nil, userInfo: ["newPrice": total])
    }
    
}





