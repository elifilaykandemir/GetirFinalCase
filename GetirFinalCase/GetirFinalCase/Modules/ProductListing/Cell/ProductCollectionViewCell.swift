//
//  ProductCollectionViewCell.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 10.04.2024.
//

import UIKit

protocol ProductCellProtocol: AnyObject {
    func setImage(_ imageData: Data?)
    func setPriceLabel(_ text: Double)
    func setProductNameLabel(_ text: String)
    func setAttributeLabel(_ text: String)
    func setStepperState(isExpanded: Bool, quantity: Int)
    func setProductID(_ id: String)
}

final class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductCollectionViewCell"
    var presenter: ProductCellPresenter! {
        didSet {
            presenter.load()
        }
    }
    lazy var stepperButton : ExpandableButton = {
        let button = ExpandableButton()
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.primaryGray.cgColor
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .primary
        label.numberOfLines = 0
        label.textAlignment = .left
        label.heightAnchor.constraint(equalToConstant: 14).isActive = true
        return label
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
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
        let stackView = UIStackView(arrangedSubviews: [priceLabel, productNameLabel, attributeLabel])
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
        contentView.addSubview(stepperButton)
        contentView.addSubview(infoStackView)
        stepperButton.delegate = self
        imageView.setupConstraints(
            leadingAnchor: contentView.leadingAnchor,
            topAnchor: contentView.topAnchor,
            trailingAnchor: contentView.trailingAnchor,
            height: nil
        )
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        stepperButton.setupConstraints(
            topAnchor: imageView.topAnchor,topConstant: -10,
            trailingAnchor: imageView.trailingAnchor,trailingConstant: 10
            
        )
        infoStackView.setupConstraints(
            leadingAnchor: contentView.leadingAnchor,leadingConstant: 10,
            topAnchor: imageView.bottomAnchor, topConstant: 4,
            trailingAnchor: contentView.trailingAnchor,trailingConstant: -10,
            bottomAnchor: contentView.bottomAnchor,bottomConstant: -8
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        priceLabel.text = nil
        productNameLabel.text = nil
        attributeLabel.text = nil
        NotificationCenter.default.removeObserver(self)
        stepperButton.reset()
        
    }
    
}

extension ProductCollectionViewCell: ProductCellProtocol {
    
    func setImage(_ imageData: Data?) {
        DispatchQueue.main.async {
            
            if let data = imageData, let image = UIImage(data: data) {
                self.imageView.image = image
            } else {
                self.imageView.image = UIImage(named: "defaultImage")
            }
        }
    }
    func setPriceLabel(_ text: Double) {
        priceLabel.text = String(format: "₺%.2f", text)
    }
    
    func setProductNameLabel(_ text: String) {
        productNameLabel.text = text.shortenedWord()
    }
    
    func setAttributeLabel(_ text: String) {
        attributeLabel.text = text
    }
    func setProductID(_ id: String) {
        stepperButton.productId = id
    }
    
    
}
extension ProductCollectionViewCell: ExpandableButtonDelegate {
    
    func didTapButton(with isExpanded: Bool) {
        updateBorderFor(isExpanded: isExpanded)
        
    }
    private func updateBorderFor(isExpanded: Bool) {
        imageView.layer.borderColor = isExpanded ? UIColor.primary.cgColor : UIColor.primaryGray.cgColor
    }
    
    func setStepperState(isExpanded: Bool, quantity: Int) {
        stepperButton.isExpanded = isExpanded
        stepperButton.count = quantity
        
        
    }
    
}
