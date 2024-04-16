//
//  String+Extension.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 16.04.2024.
//

import Foundation

extension String {
    func shortenedWord() -> String {
        let word = self.split(separator: " ")
        if word.count > 2 {
            return "\(word[0]) \(word[1])"
        } else {
            return self
        }
    }
}
