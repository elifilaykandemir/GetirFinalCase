//
//  Array+Extension.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 20.04.2024.
//

import Foundation
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
