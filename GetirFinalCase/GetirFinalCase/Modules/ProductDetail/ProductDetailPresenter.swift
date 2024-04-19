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
    var interactor: ProductDetailInteractorProtocol?
    var router: ProductDetailRouterProtocol?
    
    private var product: Product?
    private var productImages: ImageData?
    
    init(view: ProductDetailViewProtocol,
         router: ProductDetailRouterProtocol,
         interactor: ProductDetailInteractorProtocol,
         product: Product,
         productImage: ImageData?
    )
    {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.product = product
        self.productImages = productImage
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ProductDetailPresenter:ProductDetailPresenterProtocol {
    
    func didTapAddBasket() {
        //TODO: Basket Management
    }
    
    func load() {
        view?.cartButtonAction()
        view?.addToBasketButtonAction()
        view?.closeButtonAction()
        displayProductDetails()
        displayImage()
    }
    
    func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleStepperChange(_:)), name: .stepperCountDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(basketUpdated), name: .basketDidUpdate, object: nil)
        load()
        
        
    }
    private func displayProductDetails() {
        if let product = product{
            view?.displayProductDetail(priceText: product.priceText,
                                       productText: product.name, attText: product.attribute ?? "")
        }
    }
    private func displayImage() {
        if let imageData = productImages, let data = imageData.data {
            view?.setImage(image: data)
        } else {
            view?.imageNotFound()
        }
    }

  
    func cartUpdated(_ price: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.refreshCartAmount(price)
        }
    }
    
    func didTapCart() {
        router?.navigate(.basket)
    }
    
    func didTapClose(){
        router?.navigate(.list)
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
        BasketManager.shared.updateProduct(product!)
        
    }
    @objc private func basketUpdated(notification: Notification) {
        if let newPrice = notification.userInfo?["newPrice"] as? Double {
            cartUpdated(newPrice)
        }
    }
}

extension ProductDetailPresenter: ProductDetailInteractorOutput {
    func productsPassed() {
        //TODO: Data Passed
    }
    
}
