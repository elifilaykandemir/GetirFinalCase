//
//  UIView+Extension.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on
//

import Foundation
import UIKit

extension UIView{
    
    func setupConstraints(leadingAnchor: NSLayoutXAxisAnchor? = nil, leadingConstant: CGFloat = 0,
                          topAnchor: NSLayoutYAxisAnchor? = nil, topConstant: CGFloat = 0,
                          trailingAnchor: NSLayoutXAxisAnchor? = nil, trailingConstant: CGFloat = 0,
                          bottomAnchor: NSLayoutYAxisAnchor? = nil, bottomConstant: CGFloat = 0,
                          width: CGFloat? = nil, height: CGFloat? = nil,
                          centerYAnchor: NSLayoutYAxisAnchor? = nil,
                          centerXAnchor: NSLayoutXAxisAnchor? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        if let leadingAnchor = leadingAnchor {
            constraints.append(self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant))
        }
        if let topAnchor = topAnchor {
            constraints.append(self.topAnchor.constraint(equalTo: topAnchor, constant: topConstant))
        }
        if let trailingAnchor = trailingAnchor {
            constraints.append(self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstant))
        }
        if let bottomAnchor = bottomAnchor {
            constraints.append(self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant))
        }
        if let width = width {
            constraints.append(self.widthAnchor.constraint(equalToConstant: width))
        }
        if let height = height {
            constraints.append(self.heightAnchor.constraint(equalToConstant: height))
        }
        if let centerYAnchor = centerYAnchor {
            constraints.append(self.centerYAnchor.constraint(equalTo: centerYAnchor))
        }
        if let centerXAnchor = centerXAnchor {
            constraints.append(self.centerXAnchor.constraint(equalTo: centerXAnchor))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension UIView {
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.systemGray6.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        
    }
    
    func addTopShadow(){
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.systemGray6.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -2)
    }
}
