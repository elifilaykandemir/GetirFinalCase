//
//  CustonNavigationBar.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 9.04.2024.
//

import Foundation
import UIKit

class CustomNavigationBar: UIView {
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    var closeButton: UIButton?
    
    init(title: String, showCloseButton: Bool = false) {
        super.init(frame: .zero)
        backgroundColor = UIColor.primary
        titleLabel.text = title
        
        if showCloseButton {
            let closeButton = UIButton(type: .custom)
            closeButton.setImage(UIImage(named: "close"), for: .normal)
            self.closeButton = closeButton
        }
        setupUI()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(titleLabel)
        
        if let closeButton = closeButton {
            addSubview(closeButton)
        }
        titleLabel.setupConstraints(
            centerYAnchor: self.centerYAnchor,
            centerXAnchor:self.centerXAnchor
        )

        if let closeButton = closeButton {
            closeButton.setupConstraints(
                leadingAnchor: self.leadingAnchor,
                leadingConstant: 16,
                centerYAnchor: self.centerYAnchor
            )
        }
    }

    
}
