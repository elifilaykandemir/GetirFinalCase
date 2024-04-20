//
//  CustonNavigationBar.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 18.04.2024.
//
import UIKit

class CustomNavigationBar: UIView {
    
    var onCartButtonTapped: (() -> Void)?
    var onCloseTapped: (() -> Void)?
    
    func updateCartVisibility(shouldShowCartButton: Bool) {
        cartButton.isHidden = !shouldShowCartButton
    }
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private lazy var cartButton : CartButton = {
        let button = CartButton()
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    init(title: String, showCloseButton: Bool = false) {
        super.init(frame: .zero)
        backgroundColor = .primary
        
        titleLabel.text = title
        setupLayout()
        if showCloseButton {
            addSubview(closeButton)
            closeButton.setupConstraints(
                leadingAnchor: self.leadingAnchor,
                leadingConstant: 8,
                centerYAnchor: self.centerYAnchor
            )
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(cartButton)
        
        titleLabel.setupConstraints(
            centerYAnchor: self.centerYAnchor,
            centerXAnchor:self.centerXAnchor
        )
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        cartButton.setupConstraints(
            trailingAnchor: trailingAnchor,trailingConstant: -8,
            centerYAnchor: centerYAnchor
        )
        
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }
    func updateCartAmount(to amount: Double) {
        let formattedAmount = String(format: "₺%.2f", amount)
        cartButton.updatePrice(to: formattedAmount)
    }
    @objc private func cartButtonTapped() {
        onCartButtonTapped?()
    }
    @objc private func closeButtonTapped() {
        onCloseTapped?()
    }
}
