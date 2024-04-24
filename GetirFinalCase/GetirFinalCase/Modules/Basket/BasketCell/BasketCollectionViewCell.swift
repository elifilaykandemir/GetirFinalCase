//
//  BasketCollectionViewCell.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 22.04.2024.
//

import UIKit

protocol BasketCellProtocol: AnyObject {
    func setImage(from url: URL?)
    func setPriceLabel(_ text: Double)
    func setProductNameLabel(_ text: String)
    func setAttributeLabel(_ text: String)
    func configureWithProductId(_ productId: String)
}

final class BasketCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BasketCollectionViewCell"
    
    var presenter: BasketCellPresenter! {
        didSet {
            presenter.load()
        }
    }
    
    private lazy var stepperButton : HorizontalStepperButton = {
        let button = HorizontalStepperButton()
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "default")
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.primaryGray.cgColor
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .primary
        label.numberOfLines = 0
        label.textAlignment = .left
        label.heightAnchor.constraint(equalToConstant: 14).isActive = true
        return label
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.textAlignment = .left
        return label
    }()
    
    private lazy var attributeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryGray
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameLabel, attributeLabel, priceLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        presenter?.load()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(imageView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(stepperButton)
        
        imageView.setupConstraints(
            leadingAnchor: contentView.leadingAnchor,leadingConstant: 8,
            topAnchor: contentView.topAnchor,topConstant: 8,
            bottomAnchor: bottomAnchor,
            width: 100
        )
        
        infoStackView.setupConstraints(
            leadingAnchor: imageView.trailingAnchor,leadingConstant: 10,
            topAnchor: imageView.topAnchor, topConstant: 8,
            bottomAnchor: imageView.bottomAnchor,bottomConstant: -8,
            centerYAnchor: imageView.centerYAnchor
        )
        
        stepperButton.setupConstraints(
            leadingAnchor: infoStackView.trailingAnchor, leadingConstant: 36,
            trailingAnchor: contentView.trailingAnchor,trailingConstant: -8,
            centerYAnchor: imageView.centerYAnchor
        )
    }
}
extension BasketCollectionViewCell : BasketCellProtocol {
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
    }
    
    func setImage(from url: URL?) {
        guard let url = url?.secureURL() else {
            print("Invalid or nonsecure URL.")
            return
        }
        imageView.kf.setImage(with: url)
    }
    
    func setPriceLabel(_ text: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.priceLabel.text = String(format: "₺%.2f", text)
        }
    }
    
    func setProductNameLabel(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.productNameLabel.text = text.shortenedWord()
        }
    }
    
    func setAttributeLabel(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.attributeLabel.text = text
        }
        
    }
}
