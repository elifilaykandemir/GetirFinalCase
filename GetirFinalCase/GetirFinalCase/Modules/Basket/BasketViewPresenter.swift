//
//  BasketViewPresenter.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 22.04.2024.
//

import Foundation


protocol BasketViewPresenterProtocol: AnyObject {
    
    func viewDidLoad()
    func viewWillAppear()
    func numberOfItems(in section: Int) -> Int
    func didTapCloseButton()
    func didTapOkButton()
    func didTapConfirmButton()
    func product(for indexPath: IndexPath) -> Product?
    func productImageURL(for indexPath: IndexPath) -> URL?
}

final class BasketViewPresenter {
    
    weak var view: BasketViewProtocol?
    var router: BasketViewRouterProtocol?
    var interactor: BasketViewInteractorProtocol?
    
    private var products: [Section: [Product]] = [.horizontal: [], .vertical: []]
    
    init(view: BasketViewProtocol,
         router: BasketViewRouterProtocol,
         interactor: BasketViewInteractorProtocol
    )
    {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
}

extension BasketViewPresenter: BasketViewPresenterProtocol {
    
    func viewDidLoad() {
        view?.configureCollectionView()
        addNotification()
        view?.closeButtonAction()
        view?.trashButtonAction()
        view?.checkOutButtonAction()
        view?.didTapAlertConfirmAction()
        view?.didTapSuccessViewOkButtonAction()
        loadAllProduct()
    }
    
    func viewWillAppear(){
        view?.configureCollectionView()
    }
    
    
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleStepperChange(_:)), name: .stepperCountDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(basketDidUpdated), name: .basketDidUpdate, object: nil)
        
    }
   
    func numberOfItems(in section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }
        return products[sectionType]?.count ?? 0
    }
   
    
    func didTapConfirmButton() {
        BasketManager.shared.clearBasket()
        StepperCountManager.shared.resetAllCounts()
        DispatchQueue.main.async {
            self.router?.navigate(.list)
        }
    }
   
    func didTapCloseButton(){
        router?.navigate(.dismiss)
    }
    func didTapOkButton() {
        BasketManager.shared.clearBasket()
        StepperCountManager.shared.resetAllCounts()
        DispatchQueue.main.async {
            self.router?.navigate(.list)
        }
    }
    func fetchProduct() {
        interactor?.fetchProducts()
    }
    
    func loadAllProduct(){
        let allProducts = BasketManager.shared.getAllProducts()
        products[.vertical] = allProducts
    }

}
extension BasketViewPresenter {
    
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
    
    @objc private func handleStepperChange(_ notification: Notification) {
        guard let productId = notification.userInfo?["productId"] as? String,
              let newCount = notification.userInfo?["newCount"] as? Int,
              let product = product(withID: productId) else {
            return
        }
        updateProductCount(product,withCount: newCount)
    }
    
    private func updateProductCount(_ product: Product, withCount count: Int) {
        var updatedProduct = product
        updatedProduct.quantity = count
        if count > 0 {
            BasketManager.shared.addProduct(updatedProduct)
        } else {
            BasketManager.shared.removeProduct(updatedProduct)
        }
    }
   
    
    @objc private func basketDidUpdated(notification: Notification) {
        if let newPrice = notification.userInfo?["newPrice"] as? Double {
            if newPrice == 0 {
                self.router?.navigate(.list)
            }
        }
    }
}

extension BasketViewPresenter: BasketViewInteractorOutput {

    func productsFetchedSuccessfully(suggested: [Product]) {
        self.products[.horizontal] = suggested
    }
    
    func productsFetchFailed(withError: Error) {
        print("Product fetch failed with error: \(withError)")
    }
}
