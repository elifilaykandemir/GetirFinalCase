//
//  ListingPresenter.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 9.04.2024.
//

import Foundation

protocol ProductListingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func cartUpdated(_ price:Double)
    func numberOfItems(in section: Int) -> Int
    func didSelectProduct(at index: Int, in section: Section)
    func product(for indexPath: IndexPath) -> Product?
    
}
final class ProductListingPresenter {
    weak var view: ProductListingViewProtocol?
    var interactor: ProductListingInteractorProtocol?
    var router: ProductListingRouterProtocol?
    
    
    private var products: [Section: [Product]] = [.horizontal: [], .vertical: []]
    private var productImages: [Section: [ImageData]] = [.horizontal: [], .vertical: []]
    
    init(view: ProductListingViewProtocol,
         router: ProductListingRouterProtocol,
         interactor: ProductListingInteractorProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - ProductListingPresenterProtocol Implementation
extension ProductListingPresenter: ProductListingPresenterProtocol {
    func numberOfItems(in section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }
        return products[sectionType]?.count ?? 0
    }
    
    func product(for indexPath: IndexPath) -> Product? {
        guard let section = Section(rawValue: indexPath.section),
              let productsList = products[section] else { return nil }
        return productsList[safe: indexPath.row]
    }
    
    func productImage(for indexPath: IndexPath) -> ImageData? {
        guard let section = Section(rawValue: indexPath.section),
              let imagesList = productImages[section] else { return nil }
        return imagesList[safe: indexPath.row]
    }
    private func product(withID productId: String) -> Product? {
        for productsList in products.values {
            if let product = productsList.first(where: { $0.id == productId }) {
                return product
            }
        }
        return nil
    }
    
    func viewDidLoad() {
        fetchProduct()
        addNotification()
        view?.setupNavBar()
        view?.configureCollectionView()
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleStepperChange(_:)), name: .stepperCountDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(basketUpdated), name: .basketDidUpdate, object: nil)
    }
    
    @objc private func handleStepperChange(_ notification: Notification) {
        print("Notification userInfo: \(notification.userInfo ?? [:])")
        guard let productId = notification.userInfo?["productId"] as? String,
              let newCount = notification.userInfo?["newCount"] as? Int,
              let product = product(withID: productId) else {
            return
        }
        updateProductCount(product,withCount: newCount)
    }
    
    private func updateProductCount(_ product: Product, withCount count: Int) {
        if count > 0 {
            var updatedProduct = product
            updatedProduct.quantity = count
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
    
    func didSelectProduct(at index: Int, in section: Section) {
        guard let productsList = products[section],
              index < productsList.count,
              let imagesList = productImages[section],
              index < imagesList.count else { return }
        let product = productsList[index]
        let imageData = imagesList[index]
        router?.navigate(.detail(product: product, imageData: imageData))
    }
    
    func didTapCartButton() {
        router?.navigate(.basket)
    }
    
    func cartUpdated(_ price: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.refreshCartAmount(price)
        }
    }
    
    func fetchProduct() {
        Task {
            await interactor?.fetchProducts()
            await interactor?.fetchSuggestedProduct()
        }
    }
}

extension ProductListingPresenter: ProductListingInteractorOutput {
    func suggestedProductsFetchedSuccessfully(_ products: [Product], imageData: [ImageData]) {
        self.products[.horizontal] = products
        self.productImages[.horizontal] = imageData
        DispatchQueue.main.async { [weak self] in
            self?.view?.reloadProductList()
        }
    }
    
    func productsFetchedSuccessfully(_ products: [Product], imageData: [ImageData]) {
        self.products[.vertical] = products
        self.productImages[.vertical] = imageData
        DispatchQueue.main.async { [weak self] in
            self?.view?.reloadProductList()
        }
    }
    
    func productsFetchFailed(withError: Error) {
        print("Product fetch failed with error: \(withError)")
    }
}
