//
//  UIButton+Extension.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 15.04.2024.
//

import UIKit

extension UIButton {
    static func customStyledButton() -> UIButton {
        let button = UIButton()
        button.isHidden = true
        button.backgroundColor = .white
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 6
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.3
        button.layer.masksToBounds = false
        return button
    }
}


