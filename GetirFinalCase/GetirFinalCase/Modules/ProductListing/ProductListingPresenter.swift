//
//  ListingPresenter.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 9.04.2024.
//

import Foundation

protocol ProductListingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfItems() -> Int
    func product(_ index: Int) -> Product?
    func cartUpdated(_ price:Double)
    func didSelectProduct(at index: Int)
    
}

final class ProductListingPresenter {
    weak var view: ProductListingViewProtocol?
    var interactor: ProductListingInteractorProtocol?
    var router: ProductListingRouterProtocol?
    
    private var products: [Product] = []
    private var productImages: [ImageData] = []
    
    init(view: ProductListingViewProtocol,
         router: ProductListingRouterProtocol,
         interactor: ProductListingInteractorProtocol)
    {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ProductListingPresenter: ProductListingPresenterProtocol{
    
    func product(_ index: Int) -> Product? {
        return products[index]
    }
    private func product(withID productId: String) -> Product? {
        return products.first { $0.id == productId }
    }
    
    func productImage(_ index: Int) -> ImageData? {
        productImages[index]
    }
    
    func numberOfItems() -> Int {
        return products.count
    }
    @objc private func handleStepperChange(_ notification: Notification) {
        guard let productId = notification.userInfo?["productId"] as? String,
              let newCount = notification.userInfo?["newCount"] as? Int,
              let product = product(withID: productId) else {
            return
        }

        if newCount > 0 {
            var updatedProduct = product
            updatedProduct.quantity = newCount
            BasketManager.shared.addProduct(updatedProduct)
        } else {
            BasketManager.shared.removeProduct(product)
        }
        
    }
    @objc private func basketUpdated(notification: Notification) {
        if let newPrice = notification.userInfo?["newPrice"] as? Double {
            cartUpdated(newPrice)
        }
    }
    
    func viewDidLoad() {
        fetchProduct()
        NotificationCenter.default.addObserver(self, selector: #selector(handleStepperChange(_:)), name: .stepperCountDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(basketUpdated), name: .basketDidUpdate, object: nil)
        view?.setupNavBar()
        view?.configureCollectionView()
        
    }
    
    func didSelectProduct(at index: Int) {
        guard index < products.count, index < productImages.count else { return }
        let product = products[index]
        let imageData = productImages[index]
        router?.navigate(.detail(product: product, imageData: imageData))
        
    }
    
    func didTapCartButton() {
        router?.navigate(.basket)
    }
    
    func cartUpdated(_ price:Double) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.refreshCartAmount(price)
        }
    }
    
    func fetchProduct(){
        Task{
            await interactor?.fetchProducts()
        }
    }
    
}

extension ProductListingPresenter: ProductListingInteractorOutput {
    func productsFetchedSuccessfully(_ products: [Product], imageData: [ImageData]) {
        self.products = products
        self.productImages = imageData
        view?.reloadProductList()
    }
    
    func productsFetchFailed(withError: Error) {
        print("\(withError)")
    }
    
}
