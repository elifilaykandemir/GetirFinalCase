//
//  CustomSuccessView.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 22.04.2024.
//

import UIKit

final class CustomSuccessView: UIViewController {
    
    var onTapOk: (() -> Void)?
    
    let backgroundView = UIView()
    
    private lazy var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var okButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .primary
        button.layer.cornerRadius = 5
        button.setTitle("Tamam", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.addTarget(self, action: #selector(didTapOkButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.text = "Sipaşiniz alındı, ürünleriniz hazırlanıyor"
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(okButton)
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
            trailingAnchor: view.trailingAnchor, trailingConstant: -8
        )
        okButton.setupConstraints(
            topAnchor: messageLabel.bottomAnchor, topConstant: 16,
            width: 80,
            height:44,
            centerXAnchor: view.centerXAnchor
        )
    }
    
    @objc func didTapOkButton() {
        onTapOk?()
    }
}
