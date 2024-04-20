//  StepperManager.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 16.04.2024.
//

import Foundation

final class StepperCountManager {
    static let shared = StepperCountManager()
    
    private init() {}
    
    private var counts = [String: Int]()
    
    func setCount(for productId: String, to newCount: Int) {
        counts[productId] = newCount
        postNotification(for: productId)
    }
    
    func getCount(for productId: String) -> Int {
        return counts[productId] ?? 0
    }
    func incrementCount(for productId: String) {
        let currentCount = getCount(for: productId)
        setCount(for: productId, to: currentCount + 1)
    }
    
    func decrementCount(for productId: String) {
        let currentCount = getCount(for: productId)
        setCount(for: productId, to: max(currentCount - 1, 0))
        
    }
    private func postNotification(for productId: String) {
        NotificationCenter.default.post(name: .stepperCountDidChange, object: nil, userInfo: ["productId": productId, "newCount": getCount(for: productId)])
    }
}
