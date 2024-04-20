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
    
    
    private lazy var stepperButton : HorizantalStepperButton = {
        let button = HorizantalStepperButton()
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
            bottomAnchor: bottomAnchor, bottomConstant: -40,
            centerXAnchor:centerXAnchor
        )
        stepperButton.setupConstraints(
            topAnchor:topAnchor, topConstant: 16,
            bottomAnchor: bottomAnchor, bottomConstant: -40,
            centerXAnchor:centerXAnchor
        )
    }
    @objc func addToBasketButtonTapped(){
        let productId = stepperButton.productId
        
        let currentCount = StepperCountManager.shared.getCount(for: productId)
        if currentCount == 0 {
            StepperCountManager.shared.setCount(for: productId, to: 1)
            stepperButton.count = 1
        } else {
            StepperCountManager.shared.incrementCount(for: productId)
            stepperButton.count = currentCount + 1
        }
        updateViewForCurrentCount()
        onAddBasketButtonTapped?()
    }
    
    func setupStepperButton() {
        stepperButton.onDisplayedChanged = { [weak self] isHidden in
            self?.handleStepperDisplayChanged(isHidden)
        }
    }
    
    func configureWithProductId(_ productId: String) {
        stepperButton.productId = productId
        updateViewForCurrentCount()
    }
    
    func updateViewForCurrentCount() {
        let currentCount = StepperCountManager.shared.getCount(for: stepperButton.productId)
        updateViewForCount(currentCount)
    }
    
    func updateViewForCount(_ count: Int) {
        stepperButton.count = count
        let hideStepper = count == 0
        handleStepperDisplayChanged(hideStepper)
    }
    
    private func handleStepperDisplayChanged(_ isHide: Bool) {
        addBasketButton.isHidden = !isHide
        stepperButton.isHidden = isHide
    }
}
