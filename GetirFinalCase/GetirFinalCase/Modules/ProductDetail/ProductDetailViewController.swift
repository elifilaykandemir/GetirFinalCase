//
//  ProductDetailViewController.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 15.04.2024.
//

import UIKit

protocol ProductDetailViewProtocol: AnyObject {
    func displayProductDetail(priceText: String, productText: String, attText: String)
    func setImage(image:Data)
    func imageNotFound()
    func refreshCartAmount(_ amount: Double)
    func cartButtonAction()
    func addToBasketButtonAction()
    func closeButtonAction()
    func updateCartVisibility(shouldShowCartButton: Bool)
    func setProductId(_ productId: String)
}

final class ProductDetailViewController: UIViewController {
    
    var presenter: ProductDetailPresenterProtocol!

    private lazy var customNavBar = CustomNavigationBar(title:  "Ürün Detayı", showCloseButton: true)
    
    private lazy var customView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var contentView = DetailView()
    private lazy var addBasketView = AddBasketView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.viewDidLoad()
    }

  private func setupViews() {
        view.backgroundColor = .primary
        view.addSubview(customNavBar)
        view.addSubview(customView)
        customView.addSubview(contentView)
        customView.addSubview(addBasketView)
        
       customNavBar.setupConstraints(
            leadingAnchor: view.leadingAnchor,
            topAnchor: view.safeAreaLayoutGuide.topAnchor,
            trailingAnchor: view.trailingAnchor,
            height: 34
        )
        customView.setupConstraints(
            leadingAnchor: view.leadingAnchor,
            topAnchor: customNavBar.bottomAnchor,topConstant: 8,
            trailingAnchor: view.trailingAnchor,
            bottomAnchor:view.bottomAnchor
            
        )
        contentView.setupConstraints(
            leadingAnchor: customView.leadingAnchor,
            topAnchor: customView.topAnchor,
            trailingAnchor: customView.trailingAnchor,
            bottomAnchor: customView.bottomAnchor,bottomConstant: -(view.frame.width + 32)
            
        )
        addBasketView.setupConstraints(
            leadingAnchor: customView.leadingAnchor,
            topAnchor: contentView.bottomAnchor,topConstant: 320,
            trailingAnchor: customView.trailingAnchor,
            bottomAnchor: customView.bottomAnchor
        )
    }
}
extension ProductDetailViewController : ProductDetailViewProtocol {
    
    func imageNotFound() {
        contentView.setImage(UIImage(named: "defaultImage")?.pngData())
    }
    
    func displayProductDetail( priceText: String, productText: String, attText: String) {
        contentView.configureView(priceText: priceText, productText: productText, attirubuteText: attText
        )
    }
    
    func setImage(image:Data) {
        contentView.setImage(image)
    }
    
    func refreshCartAmount(_ amount: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.customNavBar.updateCartAmount(to: amount)
            self?.customNavBar.updateCartVisibility(shouldShowCartButton: amount > 0)
        }
    }
    
    func cartButtonAction(){
        customNavBar.onCartButtonTapped = { [weak self] in
            self?.presenter.didTapCart()
        }
    }
    
    func addToBasketButtonAction(){
        addBasketView.onAddBasketButtonTapped = { [weak self] in
            self?.presenter.didTapAddBasket()
        }
    }
    
    func closeButtonAction(){
        customNavBar.onCloseTapped = { [weak self] in
            self?.presenter.didTapClose()
        }
    }
    func updateCartVisibility(shouldShowCartButton: Bool) {
            DispatchQueue.main.async { [weak self] in
                self?.customNavBar.updateCartVisibility(shouldShowCartButton: shouldShowCartButton)
            }
        }
    func setProductId(_ productId: String) {
        addBasketView.configureWithProductId(productId)
    }
   
}
