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
    func cartUpdated(with: Cart)
    func didSelectProduct(at index: Int)
}

final class ProductListingPresenter {
    weak var view: ProductListingViewProtocol?
    var interactor: ProductListingInteractorProtocol?
    var router: ProductListingRouterProtocol?
    
    private var products: [Product] = []
    private var cart = Cart(products: [])
    private var productImages: [ImageData] = []
    
    init(view: ProductListingViewProtocol,
         router: ProductListingRouterProtocol,
         interactor: ProductListingInteractorProtocol)
    {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension ProductListingPresenter: ProductListingPresenterProtocol{
    func product(_ index: Int) -> Product? {
        products[index]
    }
    func productImage(_ index: Int) -> ImageData? {
        productImages[index]
    }
    
    func numberOfItems() -> Int {
        return products.count
    }
    
    
    func viewDidLoad() {
        fetchProduct()
        view?.setupNavBar()
        view?.configureCollectionView()
    }
    
    
    func didSelectProduct(at index: Int) {
        router?.navigate(.detail)
    }
    
    func didTapCartButton() {
        router?.navigate(.basket)
    }
    
    
    func addProductToCart(_ product: Product) {
        cart.products.append(product)
        //view?.updateCartDisplay(cart)
    }
    
    func cartUpdated(with cart: Cart) {
        view?.refreshCartAmount(cart.totalAmount)
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
        print(self.products)
        print(self.productImages)
        view?.reloadProductList()
    }
    
    func productsFetchFailed(withError: Error) {
        print("\(withError)")
    }
    
  
    

    
}
