//
//  CusNav.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 18.04.2024.
//

import UIKit

class CusNav: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupview()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupview()
    }

    func setupview() {
        tintColor = .white
        backgroundColor = .primary
        clipsToBounds = true
      }

}
