import UIKit

protocol StepperButtonDelegate: AnyObject {
    func didTapButton(with: Bool)
}
final class StepperButton: UIView {
    
    var productId: String = ""
    
    var isExpanded: Bool = false {
        didSet {
            updateButtonAppearance()
        }
    }
    
    var count: Int {
        get { StepperCountManager.shared.getCount(for: productId) }
        set {
            StepperCountManager.shared.setCount(for: productId, to: newValue)
            updateButtonAppearance()
        }
    }
    
    weak var delegate: StepperButtonDelegate?
    
    private lazy var plusButton: CustomButton = {
        let button = CustomButton(frame: .zero, icon: "plus")
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var trashButton: UIButton = {
        let button = UIButton.customStyledButton()
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
        label.isHidden = true
        return label
    }()

    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(plusButton)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(trashButton)
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialExpand() {
        isExpanded = true
        count = 1
        delegate?.didTapButton(with: isExpanded)
        updateExpandButton()
    }
    
    private func increaseCount() {
        StepperCountManager.shared.incrementCount(for: productId)
        print("Increaed count",count)
        updateButtonAppearance()
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
        if count <= 1 {
            isExpanded = false
            updateExpandButton()
            delegate?.didTapButton(with: isExpanded)
        }
    }
    
    @objc func plusButtonTapped() {
        if isExpanded {
            increaseCount()
        } else {
            initialExpand()
        }
    }
    
    private func updateExpandButton() {
        self.countLabel.isHidden = !self.isExpanded
        self.trashButton.isHidden = !self.isExpanded || self.count > 1
        if self.isExpanded {
            self.plusButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            self.plusButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    private func updateButtonAppearance() {
        let symbol = count > 1 ? "minus" : "trash"
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        let icon = UIImage(systemName: symbol, withConfiguration: config)
        trashButton.setImage(icon, for: .normal)
        trashButton.tintColor = .primary
        
        countLabel.text = "\(count)"
        countLabel.isHidden = self.count == 0
        trashButton.isHidden = self.count == 0
    }
    
    
    private func setupStackView() {
        addSubview(containerStackView)
        
    }
    
    private func setupConstraints() {
        plusButton.setupConstraints(
            width: 30,
            height: 30
        )
        countLabel.setupConstraints(
            width: 30,
            height: 30
        )
        
        trashButton.setupConstraints(
            width: 30,
            height: 30
        )
        containerStackView.setupConstraints(
            leadingAnchor: leadingAnchor,
            topAnchor: topAnchor,
            trailingAnchor: trailingAnchor,
            bottomAnchor: bottomAnchor
        )
    }
}
extension StepperButton {
    func reset() {
        updateButtonAppearance()
        updateExpandButton()
    }
}
