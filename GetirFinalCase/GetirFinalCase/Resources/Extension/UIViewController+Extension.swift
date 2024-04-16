//
//  UIViewController+Extension.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 10.04.2024.
//

import UIKit

extension UIViewController {
    func configureNavigationBarAppearance(color: UIColor) {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = color
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = color
            navigationController?.navigationBar.isTranslucent = false
        }
    }
}
