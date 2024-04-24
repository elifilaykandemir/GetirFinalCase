//
//  BasketViewRouter.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 22.04.2024.
//

import Foundation

enum BasketViewRoutes {
    case list
    case dismiss
}

protocol BasketViewRouterProtocol: AnyObject {
    func navigate(_ route: BasketViewRoutes)
}

final class BasketViewRouter {
    
    weak var viewController: BasketViewController?
    
    static func createModule() -> BasketViewController {
        
        let view = BasketViewController()
        let interactor = BasketViewInteractor()
        let router = BasketViewRouter()
        
        let presenter = BasketViewPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
   
        return view
    }
}

extension BasketViewRouter: BasketViewRouterProtocol {
    
    func navigate(_ route: BasketViewRoutes) {
        switch route {
        case .dismiss:
            viewController?.dismiss(animated: true)
        case .list:
            let vc = ProductListingRouter.createModule()
            vc.modalPresentationStyle = .fullScreen
            if let presentedVC = viewController?.presentedViewController {
                presentedVC.dismiss(animated: true) {
                    self.viewController?.present(vc, animated: true, completion:nil)
                }
            }
            else {
                viewController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
