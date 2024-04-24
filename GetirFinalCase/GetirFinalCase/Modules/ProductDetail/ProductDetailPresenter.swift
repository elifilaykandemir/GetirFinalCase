//
//  ProductDetailPresenter.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 18.04.2024.
//

import Foundation

protocol ProductDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func cartUpdated(_ price:Double)
    func didTapCart()
    func didTapClose()
    func didTapAddBasket()
    func load()
}

final class ProductDetailPresenter {
    weak var view: ProductDetailViewProtocol?
    var router: ProductDetailRouterProtocol?
    
    private var product: Product?
    private var productImages: URL?
    
    init(view: ProductDetailViewProtocol,
         router: ProductDetailRouterProtocol,
         product: Product,
         productImage: URL?
    )
    {
        self.view = view
        self.router = router
        self.product = product
        self.productImages = productImage
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ProductDetailPresenter:ProductDetailPresenterProtocol {
    
    func load() {
        passedProductID()
        view?.cartButtonAction()
        view?.addToBasketButtonAction()
        view?.closeButtonAction()
        displayProductDetails()
        displayImage()
        updateCartButtonVisibility()
    }
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleStepperChange(_:)), name: .stepperCountDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(basketUpdated), name: .basketDidUpdate, object: nil)
        load()
        setInitialCardAmaunt()
    }
    
    private func setInitialCardAmaunt(){
        let initialCardAmount = BasketManager.shared.total
        cartUpdated(initialCardAmount)
    }
    
    private func passedProductID(){
        guard let product = self.product else { return }
        view?.setProductId(product.id)
    }
    
    private func displayProductDetails() {
        if let product = product{
            view?.displayProductDetail(
                priceText: product.priceText,
                productText: product.name,
                attText: product.attribute ?? "")
        }
    }
    private func displayImage() {
        if let image = productImages {
            view?.setImage(image: image)
        } else {
            print("Image not found")
        }
    }
    
    func cartUpdated(_ price: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.refreshCartAmount(price)
        }
    }
    
    func didTapAddBasket() {
        cartUpdated(BasketManager.shared.total)
    }
    
    func didTapCart() {
        router?.navigate(.basket)
    }
    
    func didTapClose(){
        router?.navigate(.list)
    }
    func updateCartButtonVisibility() {
        let displayCartButton = BasketManager.shared.total > 0
        view?.updateCartVisibility(shouldShowCartButton: displayCartButton)
    }
    
}
extension ProductDetailPresenter {
    
    @objc private func handleStepperChange(_ notification: Notification) {
        guard let productId = notification.userInfo?["productId"] as? String,
              productId == product?.id,
              let newCount = notification.userInfo?["newCount"] as? Int else {
            return
        }
        product?.quantity = newCount
    }
    
    @objc private func basketUpdated(notification: Notification) {
        if let newPrice = notification.userInfo?["newPrice"] as? Double {
            cartUpdated(newPrice)
            updateCartButtonVisibility()
        }
    }
}
