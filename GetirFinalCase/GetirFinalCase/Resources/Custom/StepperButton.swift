import UIKit

protocol StepperButtonDelegate: AnyObject {
    func didTapButton(with: Bool)
}
class StepperButton: UIView {
    
    var productId: String = ""
    
    var isExpanded: Bool = false {
        didSet {
            updateButtonAppearance()
            adjustButtonTargets()
        }
    }
    typealias ChangeHandler = (Bool) -> Void
    
    var onDisplayedChanged: ChangeHandler?
    
    var count: Int {
        get { StepperCountManager.shared.getCount(for: productId) }
        set {
            StepperCountManager.shared.setCount(for: productId, to: newValue)
            updateButtonAppearance()
            onDisplayedChanged?(newValue == 0)
        }
    }
    
    weak var delegate: StepperButtonDelegate?
    
    private lazy var plusButton: CustomButton = {
        let button = CustomButton(frame: .zero, icon: "plus")
        button.addTarget(self, action: #selector(initialExpand), for: .touchUpInside)
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
    
    private lazy var expandedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isHidden = true
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(trashButton)
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(plusButton)
        stackView.addArrangedSubview(expandedStackView)
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
    
    @objc private func initialExpand() {
        isExpanded = true
        count = 1
        delegate?.didTapButton(with: isExpanded)
        updateExpandAnimation()
    }
    
    
    @objc private func toggleExpandCollapse() {
        increaseCount()
        
    }
    
    @objc private func increaseCount() {
        StepperCountManager.shared.incrementCount(for: productId)
        updateButtonAppearance()
    }
    
    @objc private func decreaseCount() {
        StepperCountManager.shared.decrementCount(for: productId)
        let updatedCount = StepperCountManager.shared.getCount(for: productId)
        count = updatedCount
        if count <= 0 {
            trashButtonTapped()
        } else {
            updateButtonAppearance()
        }
    }
    
    @objc private func trashButtonTapped() {
        StepperCountManager.shared.setCount(for: productId, to: 0)
        count = 0
        if count <= 1 {
            isExpanded = false
            updateExpandAnimation()
            delegate?.didTapButton(with: isExpanded)
        }
    }
    
    private func adjustButtonTargets() {
        plusButton.removeTarget(nil, action: nil, for: .allEvents)
        if isExpanded {
            plusButton.addTarget(self, action: #selector(toggleExpandCollapse), for: .touchUpInside)
        } else {
            plusButton.addTarget(self, action: #selector(initialExpand), for: .touchUpInside)
        }
    }
    
    private func updateExpandAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.expandedStackView.isHidden = !self.isExpanded
            self.countLabel.isHidden = self.count == 0
            self.trashButton.isHidden = self.count == 0
            
            if self.isExpanded {
                self.plusButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                self.plusButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
            self.updateButtonAppearance()
            self.layoutIfNeeded()
        })
    }
    
    private func updateButtonAppearance() {
        let symbol = count > 1 ? "minus" : "trash"
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        let icon = UIImage(systemName: symbol, withConfiguration: config)
        trashButton.setImage(icon, for: .normal)
        trashButton.tintColor = .primary
        
        countLabel.text = "\(count)"
        countLabel.alpha = isExpanded ? 1 : 0
        trashButton.alpha = isExpanded && count > 0 ? 1 : 0
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
        count = 0
        isExpanded = false
        updateButtonAppearance()
        updateExpandAnimation()
    }
}
