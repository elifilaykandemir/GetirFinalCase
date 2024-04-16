//
//  UIFont+Extension.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 14.04.2024.
//

import Foundation
import UIKit

extension UIFont {
    static func openSans(ofSize size: CGFloat, weight: OpenSansWeight = .regular) -> UIFont {
        let fontName = weight.rawValue
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

enum OpenSansWeight: String {
    case regular = "OpenSans-Regular"
    case bold = "OpenSans-Bold"
}
