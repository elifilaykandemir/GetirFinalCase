//
//  ProductDetailRouter.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 18.04.2024.
//

import Foundation


enum ProductDetailRoutes {
    case list
    case basket
   
}

protocol ProductDetailRouterProtocol: AnyObject {
    func navigate(_ route: ProductDetailRoutes)
}

final class ProductDetailRouter {
    
    weak var viewController: ProductDetailViewController?
    
    static func createModule(with product: Product, imageData: URL?) -> ProductDetailViewController {
        
        let view = ProductDetailViewController()
        let router = ProductDetailRouter()
        
        let presenter = ProductDetailPresenter(view: view, router: router, product: product, productImage:imageData)
        view.presenter = presenter
        router.viewController = view
   
        return view
    }
}

extension ProductDetailRouter: ProductDetailRouterProtocol {
    
    func navigate(_ route: ProductDetailRoutes) {
        switch route {
        case .list:
            viewController?.dismiss(animated: true)
        case .basket:
            let basketVC = BasketViewRouter.createModule()
            basketVC.modalPresentationStyle = .fullScreen
            viewController?.present(basketVC, animated: true)
        }
    }
}
