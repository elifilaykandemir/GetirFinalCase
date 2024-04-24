//
//  CustomPlusButton.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 11.04.2024.
//
import UIKit

final class PlusButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        if let plusImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold))?.withTintColor(.primary, renderingMode: .alwaysOriginal) {
            setImage(plusImage, for: .normal)
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
