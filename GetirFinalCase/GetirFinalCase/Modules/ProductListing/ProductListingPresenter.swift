//
//  ListingPresenter.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 9.04.2024.
//

import Foundation

protocol ProductListingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func cartUpdated(_ price:Double)
    func numberOfItems(in section: Int) -> Int
    func didSelectProduct(at index: Int, in section: Section)
    func product(for indexPath: IndexPath) -> Product?
    func productImageURL(for indexPath: IndexPath) -> URL?
    
}
final class ProductListingPresenter {
    weak var view: ProductListingViewProtocol?
    var interactor: ProductListingInteractorProtocol?
    var router: ProductListingRouterProtocol?
    
    
    private var products: [Section: [Product]] = [.horizontal: [], .vertical: []]
    
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
        return productsList[safe: indexPath.item]
    }

    private func product(withID productId: String) -> Product? {
        for productsList in products.values {
            if let product = productsList.first(where: { $0.id == productId }) {
                return product
            }
        }
        return nil
    }
    func productImageURL(for indexPath: IndexPath) -> URL? {
        guard let section = Section(rawValue: indexPath.section),
              let product = products[section]?[indexPath.row] else {
            return nil
        }
        return product.imageURLAsURL
    }
    
    func viewDidLoad() {
        fetchProduct()
        addNotification()
        view?.setupNavBar()

    }
    
    func viewWillAppear(){
        view?.configureCollectionView()
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleStepperChange(_:)), name: .stepperCountDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(basketUpdated), name: .basketDidUpdate, object: nil)
    }
    
    @objc private func handleStepperChange(_ notification: Notification) {
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
    
    func didSelectProduct(at index: Int, in section: Section)  {
        guard let productsList = products[section],
              index < productsList.count else {
            print("Index out of bounds or section not found.")
            return
        }
        let product = productsList[index]

        guard let imageURL = product.imageURLAsURL else {
            print("Product image URL is missing.")
            return
        }
        guard let url = imageURL.secureURL() else {
                print("Invalid or non-secure URL.")
                return
            }

        router?.navigate(.detail(product: product, imageData: url))
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
        interactor?.fetchProducts()
    }
}

extension ProductListingPresenter: ProductListingInteractorOutput {

    func productsFetchedSuccessfully(_ products: (regular: [Product], suggested: [Product])) {
        self.products[.vertical] = products.regular
        self.products[.horizontal] = products.suggested
        DispatchQueue.main.async { [weak self] in
            self?.view?.reloadProductList()
        }
    }
    
    func productsFetchFailed(withError: Error) {
        print("Product fetch failed with error: \(withError)")
    }
}

