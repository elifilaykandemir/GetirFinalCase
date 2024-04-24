//
//  BasketNavigationBar.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 22.04.2024.
//

import Foundation
import UIKit

final class BasketNavigationBar: UIView {
    
    var onTrashButtonTapped: (() -> Void)?
    var onCloseTapped: (() -> Void)?
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private lazy var trashButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .primary
        titleLabel.text = title
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(trashButton)
        
        closeButton.setupConstraints(
            leadingAnchor: self.leadingAnchor,
            leadingConstant: 16,
            centerYAnchor: self.centerYAnchor
        )
        titleLabel.setupConstraints(
            centerYAnchor: self.centerYAnchor,
            centerXAnchor:self.centerXAnchor
        )
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        trashButton.setupConstraints(
            trailingAnchor: trailingAnchor,trailingConstant: -16,
            centerYAnchor: centerYAnchor
        )
    }
    
    @objc private func trashButtonTapped() {
        onTrashButtonTapped?()
    }
    
    @objc private func closeButtonTapped() {
        onCloseTapped?()
    }
}
