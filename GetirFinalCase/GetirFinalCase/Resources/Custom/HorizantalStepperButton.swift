//
//  HorizantalStepperButton.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 19.04.2024.

import UIKit


final class HorizontalStepperButton: UIView {

    var productId: String = ""
    
    typealias ChangeHandler = (Bool) -> Void
    var onDisplayedChanged: ChangeHandler?
    var onTapTrashButton: (() -> Void)?
   
    var count: Int {
        get { StepperCountManager.shared.getCount(for: productId) }
        set {
            StepperCountManager.shared.setCount(for: productId, to: newValue)
            updateButtonAppearance()
            onDisplayedChanged?(newValue == 0)
        }
    }
    
    private lazy var plusButton: CustomButton = {
        let button = CustomButton(frame: .zero, icon: "plus")
        button.addTarget(self, action: #selector(tappedPlusButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var trashButton: CustomButton = {
        let button = CustomButton(frame: .zero, icon: "trash")
        button.addTarget(self, action: #selector(decreaseCount), for: .touchUpInside)
        return button
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .primary
        label.layer.cornerRadius = 6
        label.isHidden = false
        return label
    }()

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(trashButton)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(plusButton)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupConstraints()
        setupObservers()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleCountChange(notification:)), name: .stepperCountDidChange, object: nil)
    }
    
    @objc private func handleCountChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let id = userInfo["productId"] as? String,
              id == productId else {
            return
        }
        let newCount = userInfo["newCount"] as? Int ?? 0
        DispatchQueue.main.async {
            self.countLabel.text = "\(newCount)"
            self.updateButtonAppearance()
        }
    }
    
    @objc private func tappedPlusButton() {
        increaseCount()
    }
    
    @objc private func increaseCount() {
        StepperCountManager.shared.incrementCount(for: productId)
    }
    
    @objc private func decreaseCount() {
        StepperCountManager.shared.decrementCount(for: productId)
        if count <= 0 {
            trashButtonTapped()
        } else {
            updateButtonAppearance()
        }
    }
    
    @objc private func trashButtonTapped() {
        onDisplayedChanged?(true)
        isHidden = true
        count = 0
        onTapTrashButton?()
    }
 
    private func updateButtonAppearance() {
        countLabel.text = "\(count)"
        let symbol = count > 1 ? "minus" : "trash"
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        let icon = UIImage(systemName: symbol, withConfiguration: config)
        trashButton.setImage(icon, for: .normal)
        trashButton.tintColor = .primary
    }
    
        private func setupStackView() {
            addSubview(containerStackView)
        }
    
        private func setupConstraints() {
            plusButton.setupConstraints(
                width: 40,
                height: 40
            )
            countLabel.setupConstraints(
                width: 40,
                height: 40
            )
    
            trashButton.setupConstraints(
                width: 40,
                height: 40
            )
            containerStackView.setupConstraints(
                leadingAnchor: leadingAnchor,
                topAnchor: topAnchor,
                trailingAnchor: trailingAnchor,
                bottomAnchor: bottomAnchor
            )
        }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
