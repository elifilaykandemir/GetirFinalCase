import UIKit

protocol ExpandableButtonDelegate: AnyObject {
    func didChangeQuantity(to quantity: Int)
    func didTapButton(with: Bool)
}
class ExpandableButton: UIView {
    
    var isExpanded: Bool = false {
        didSet {
            updateButtonAppearance()
        }
    }
    
    var count: Int = 0 {
        didSet {
            updateButtonAppearance()
            delegate?.didChangeQuantity(to: count)
        }
    }
    weak var delegate: ExpandableButtonDelegate?
    
    private lazy var plusButton: CustomButton = {
        let button = CustomButton(frame: .zero, icon: "plus")
        button.addTarget(self, action: #selector(toggleExpandCollapse), for: .touchUpInside)
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

    @objc private func toggleExpandCollapse() {
        
        if !isExpanded {
            isExpanded = true
            delegate?.didTapButton(with:isExpanded)
            if count == 0 {
                count = 1
            }
        } else {
            increaseCount()
        }
        
        updateExpandAnimation()
    }

    @objc private func increaseCount() {
        count += 1
        updateButtonAppearance()
    }

    @objc private func decreaseCount() {
        count -= 1
        if count <= 0 {
                trashButtonTapped()
            } else {
                updateButtonAppearance()
            }
    }

    @objc private func trashButtonTapped() {
        if count <= 1 {
                isExpanded = false
                count = 0
                updateExpandAnimation()
            delegate?.didTapButton(with: isExpanded)
            } else {
                decreaseCount()
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

