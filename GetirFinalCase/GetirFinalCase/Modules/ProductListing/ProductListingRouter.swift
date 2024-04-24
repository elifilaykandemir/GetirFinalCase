//
//  ListingRouter.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 9.04.2024.
//

import Foundation

enum ProductListRoutes {
    case detail(product: Product, imageData: URL)
    case basket
}

protocol ProductListingRouterProtocol: AnyObject {
    func navigate(_ route: ProductListRoutes)
}

final class ProductListingRouter {
    
    weak var viewController: ProductListingViewController?
    
    static func createModule() -> ProductListingViewController {
        
        let view = ProductListingViewController()
        let interactor = ProductListingInteractor()
        let router = ProductListingRouter()
        let presenter = ProductListingPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
   
        return view
    }
}

extension ProductListingRouter: ProductListingRouterProtocol {
    
    func navigate(_ route: ProductListRoutes) {
        switch route {
        case .detail(let product, let imageData):
            let productDetailVC = ProductDetailRouter.createModule(with: product, imageData: imageData)
            productDetailVC.modalPresentationStyle = .fullScreen
            viewController?.present(productDetailVC, animated: true)
        case .basket:
            let basketVC = BasketViewRouter.createModule()
            basketVC.modalPresentationStyle = .fullScreen
            viewController?.present(basketVC, animated: true)

        }
    }
}
