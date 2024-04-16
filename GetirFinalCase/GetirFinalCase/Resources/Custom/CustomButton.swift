//
//  CustomButton.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 14.04.2024.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    private let icon: String
    
    init(frame: CGRect, icon: String) {
        self.icon = icon
        super.init(frame: frame)
        commonInit()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        if let iconImage = UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .bold))?.withTintColor(.primary, renderingMode: .alwaysOriginal) {
            setImage(iconImage, for: .normal)
        }
       
        backgroundColor = .white
        
        layer.cornerRadius = 6
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.white.cgColor
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
    
}
