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
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension URL {
    func secureURL() -> URL? {
        guard self.scheme != "https" else {
            return self
        }
        
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        
        return components?.url
    }
}


