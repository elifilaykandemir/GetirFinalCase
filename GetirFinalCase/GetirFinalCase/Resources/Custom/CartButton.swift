import UIKit

class CartButton: UIButton {
    
    private lazy var iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "basket", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold))?.withTintColor(.primary, renderingMode: .alwaysOriginal)
        
        return imageView
    }()
    
    private lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primary
        label.backgroundColor = .primaryGray
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, priceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center

        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        configureButton()
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        backgroundColor = .white
        clipsToBounds = true
    }
    
    private func configureStackView() {
        addSubview(stackView)
        priceLabel.setupConstraints(
            topAnchor: topAnchor,topConstant: -1,
            trailingAnchor: trailingAnchor,trailingConstant: -1,
            bottomAnchor: bottomAnchor,bottomConstant: 1
        )
        stackView.setupConstraints(
            leadingAnchor: leadingAnchor, leadingConstant:12,
            topAnchor: topAnchor,topConstant: 5,
            trailingAnchor: trailingAnchor,trailingConstant: -12,
            bottomAnchor: bottomAnchor,bottomConstant: -5
        )
    }
   
    func updatePrice(to newPrice: String) {
        DispatchQueue.main.async {
            self.priceLabel.text = newPrice
            self.priceLabel.sizeToFit()
        }
    }
}

