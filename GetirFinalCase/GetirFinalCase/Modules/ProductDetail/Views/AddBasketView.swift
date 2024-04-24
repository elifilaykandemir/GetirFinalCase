//
//  AddBasketView.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 19.04.2024.
//

import UIKit

final class AddBasketView: UIView {
    
    var onAddBasketButtonTapped: (() -> Void)?
    
    private lazy var addBasketButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sepete Ekle", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .primary
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addToBasketButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stepperButton : HorizontalStepperButton = {
        let button = HorizontalStepperButton()
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupConstraints()
        setupView()
        setupStepperButton()
    }
    private func setupView() {
        addTopShadow()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupConstraints() {
        addSubview(addBasketButton)
        addSubview(stepperButton)
        addBasketButton.setupConstraints(
            leadingAnchor: leadingAnchor, leadingConstant: 16,
            topAnchor:topAnchor, topConstant: 16,
            trailingAnchor: trailingAnchor, trailingConstant: -16,
            height: 48, centerXAnchor:centerXAnchor
        )
        stepperButton.setupConstraints(
            topAnchor:topAnchor, topConstant: 16,
            bottomAnchor: bottomAnchor, bottomConstant: -40,
            centerXAnchor:centerXAnchor
        )
    }
    
    func setupStepperButton() {
        stepperButton.onDisplayedChanged = { [weak self] isEmpty in
            self?.handleStepperDisplayChanged(isEmpty)
        }
    }
    
    func configureWithProductId(_ productId: String) {
        stepperButton.productId = productId
        updateViewForCurrentCount()
    }
    
    private func updateViewForCurrentCount() {
        let currentCount = StepperCountManager.shared.getCount(for: stepperButton.productId)
        updateViewForCount(currentCount)
    }
    
    private func updateViewForCount(_ count: Int) {
        stepperButton.count = count
        handleStepperDisplayChanged(count == 0)
    }
    
    private func handleStepperDisplayChanged(_ isHideStepper: Bool) {
        stepperButton.isHidden = isHideStepper
        addBasketButton.isHidden = !isHideStepper
    }
    
    @objc func addToBasketButtonTapped() {
        let productId = stepperButton.productId
        StepperCountManager.shared.setCount(for: productId, to: 1)
        stepperButton.count = 1
        updateViewForCurrentCount()
        onAddBasketButtonTapped?()
    }
}
