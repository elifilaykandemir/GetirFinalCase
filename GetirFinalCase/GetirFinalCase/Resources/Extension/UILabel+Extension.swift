//
//  UILabel+Extension.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 14.04.2024.
//

import Foundation
import UIKit

extension UILabel {
    static var boldPrimary: UILabel {
        let label = UILabel()
        label.font = UIFont.openSans(ofSize: 14)
        return label
    }

   static var regularPrimary: UILabel {
        let label = UILabel()
        label.font = UIFont.openSans(ofSize: 12)
        return label
    }
    static var boldSecondary: UILabel {
         let label = UILabel()
         label.font = UIFont.openSans(ofSize: 10)
         return label
     }

}
