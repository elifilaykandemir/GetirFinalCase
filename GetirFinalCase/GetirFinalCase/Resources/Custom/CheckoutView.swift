//
//  CompleteOrderView.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 22.04.2024.
//

import UIKit

final class CheckOutView: UIView {
    
    var onCheckoutButtonTapped: (() -> Void)?
    
    private lazy var checkOutLabel: UILabel = {
        let label = UILabel()
        label.text = "Siparişi Tamamla"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .primary
        label.layer.cornerRadius = 10
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .primary
        label.textAlignment = .center
        label.backgroundColor = .white
        label.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var checkoutButton: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [checkOutLabel, priceLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.isUserInteractionEnabled = true
        stack.layer.cornerRadius = 10
        stack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCheckoutView)))
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(basketDidUpdated), name: .basketDidUpdate, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func basketDidUpdated(notification: Notification) {
        if let newPrice = notification.userInfo?["newPrice"] as? Double {
            updateCartAmount(to: newPrice)
        }
    }
    private func setupView() {
        checkoutButton.layer.shadowColor = UIColor.black.cgColor
        checkoutButton.layer.shadowOpacity = 0.2
        checkoutButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        checkoutButton.layer.shadowRadius = 4
        checkoutButton.layer.cornerRadius = 10 
        checkoutButton.layer.borderWidth = 0.5
        checkoutButton.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(checkoutButton)
        checkoutButton.setupConstraints(
            leadingAnchor: leadingAnchor, leadingConstant: 16,
            topAnchor:topAnchor, topConstant: 16,
            trailingAnchor: trailingAnchor, trailingConstant: -24,
            bottomAnchor: bottomAnchor, bottomConstant: -32
        )
        priceLabel.setupConstraints(
            topAnchor:checkoutButton.topAnchor,
            bottomAnchor:checkoutButton.bottomAnchor
        
        )
        checkOutLabel.setupConstraints(
            leadingAnchor: checkoutButton.leadingAnchor,
            topAnchor:checkoutButton.topAnchor,
            bottomAnchor:checkoutButton.bottomAnchor
        )
    }
    
    @objc func didTapCheckoutView(){
        onCheckoutButtonTapped?()
    }
    
    func updateCartAmount(to amount: Double) {
        let formattedAmount = String(format: "₺%.2f", amount)
        updatePrice(to: formattedAmount)
    }
    
    private func updatePrice(to newPrice: String) {
        DispatchQueue.main.async {
            self.priceLabel.text = newPrice
            self.priceLabel.sizeToFit()
        }
    }
}
