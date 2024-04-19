//
//  DetailView.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 18.04.2024.
//

import UIKit

class DetailView: UIView {
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "default")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .primary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var attributeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(attributeLabel)
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupStackView()
        setupConstraints()
        setupView()
    }
    private func setupView() {
        addBottomShadow()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        addSubview(productImageView)
        addSubview(containerStackView)
        
    }
    
    private func setupConstraints() {
        productImageView.setupConstraints(
            topAnchor: self.topAnchor,topConstant: 16,
            width: 200,
            height:200,
            centerXAnchor: self.centerXAnchor
        )
        containerStackView.setupConstraints(
            leadingAnchor: leadingAnchor, leadingConstant: 16,
            topAnchor: productImageView.bottomAnchor, topConstant: 8,
            trailingAnchor: trailingAnchor,trailingConstant: -16,
            centerXAnchor: self.centerXAnchor
        )
        

    }
    func configureView(priceText:String,productText:String, attirubuteText:String){
        priceLabel.text = priceText
        productNameLabel.text = productText
        attributeLabel.text = attirubuteText
    }
    func setImage(_ imageData: Data?) {
        DispatchQueue.main.async {
            
            if let data = imageData, let image = UIImage(data: data) {
                self.productImageView.image = image
            } else {
                self.productImageView.image = UIImage(named: "defaultImage")
            }
        }
    }
}
