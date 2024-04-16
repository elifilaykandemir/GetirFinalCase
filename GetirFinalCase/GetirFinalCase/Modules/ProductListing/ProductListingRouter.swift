//
//  ListingRouter.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 9.04.2024.
//

import Foundation

enum ProductListRoutes {
    case detail
    case basket
    //case detail
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
        case .detail:
//            let productDetailVC = productDetailRouter.createModule()
//            viewController?.navigationController?.pushViewController(productDetailVC, animated: true)
            let vc = ProductDetailViewController()
            viewController?.navigationController?.pushViewController(vc, animated: true)
        case .basket:
//            let basketVC = basketRouter.createModule()
//            viewController?.navigationController?.pushViewController(basketVC, animated: true)
            let vc = BasketViewController()
            viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
