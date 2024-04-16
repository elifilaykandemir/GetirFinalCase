//
//  UIView+Extension.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on
//

import Foundation
import UIKit

extension UIView{
    
    func pin(to superView:UIView){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
  
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
    func setupDynamicConstraints(leadingAnchor: NSLayoutXAxisAnchor? = nil, leadingMultiplier: CGFloat = 0,
                                 topAnchor: NSLayoutYAxisAnchor? = nil, topMultiplier: CGFloat = 0,
                                 trailingAnchor: NSLayoutXAxisAnchor? = nil, trailingMultiplier: CGFloat = 0,
                                 bottomAnchor: NSLayoutYAxisAnchor? = nil, bottomMultiplier: CGFloat = 0,
                                 widthMultiplier: CGFloat? = nil, heightMultiplier: CGFloat? = nil,
                                 centerYAnchor: NSLayoutYAxisAnchor? = nil, centerXAnchor: NSLayoutXAxisAnchor? = nil) {
        translatesAutoresizingMaskIntoConstraints = false

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        var constraints = [NSLayoutConstraint]()

        if let leading = leadingAnchor {
            constraints.append(self.leadingAnchor.constraint(equalTo: leading, constant: screenWidth * leadingMultiplier))
        }
        if let top = topAnchor {
            constraints.append(self.topAnchor.constraint(equalTo: top, constant: screenHeight * topMultiplier))
        }
        if let trailing = trailingAnchor {
            constraints.append(self.trailingAnchor.constraint(equalTo: trailing, constant: -screenWidth * trailingMultiplier))
        }
        if let bottom = bottomAnchor {
            constraints.append(self.bottomAnchor.constraint(equalTo: bottom, constant: -screenHeight * bottomMultiplier))
        }
        if let widthMult = widthMultiplier {
            constraints.append(self.widthAnchor.constraint(equalToConstant: screenWidth * widthMult))
        }
        if let heightMult = heightMultiplier {
            constraints.append(self.heightAnchor.constraint(equalToConstant: screenHeight * heightMult))
        }
        if let centerY = centerYAnchor {
            constraints.append(self.centerYAnchor.constraint(equalTo: centerY))
        }
        if let centerX = centerXAnchor {
            constraints.append(self.centerXAnchor.constraint(equalTo: centerX))
        }

        NSLayoutConstraint.activate(constraints)
    }

    }
