//
//  CustomAlertView.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 22.04.2024.
//

import UIKit

class CustomAlertView: UIViewController {
    
    var onTapCancel: (() -> Void)?
    var onTapConfirm: (() -> Void)?
    
    private lazy var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Sepetini boşaltmak istediğinden emin misin?"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cancelButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray2
        button.layer.cornerRadius = 5
        button.setTitle("Hayır", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .primary
        button.layer.cornerRadius = 5
        button.setTitle("Evet", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(cancelButton)
        containerView.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        containerView.setupConstraints(
            leadingAnchor: view.leadingAnchor, leadingConstant: 16,
            trailingAnchor: view.trailingAnchor, trailingConstant: -16,
            height: 100,
            centerYAnchor: view.centerYAnchor
        )
        messageLabel.setupConstraints(
            leadingAnchor: containerView.leadingAnchor, leadingConstant: 8,
            topAnchor: containerView.topAnchor, topConstant: 16,
            trailingAnchor: containerView.trailingAnchor, trailingConstant: -8
        )
        cancelButton.setupConstraints(
            leadingAnchor: containerView.leadingAnchor, leadingConstant: 8,
            topAnchor: messageLabel.bottomAnchor, topConstant: 16,
            height: 44
        )
        confirmButton.setupConstraints(
            leadingAnchor: cancelButton.trailingAnchor, leadingConstant: 8,
            topAnchor: messageLabel.bottomAnchor, topConstant: 16,
            trailingAnchor: containerView.trailingAnchor, trailingConstant: -8,
            height: 44
        )
        cancelButton.widthAnchor.constraint(equalTo: confirmButton.widthAnchor).isActive = true
    }
    
    @objc func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmAction() {
        onTapConfirm?()
    }
}
