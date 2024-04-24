//
//  BasketViewInteractor.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 22.04.2024.
//

import Foundation
protocol BasketViewInteractorProtocol: AnyObject {
    func fetchProducts()
}

protocol BasketViewInteractorOutput: AnyObject {
    func productsFetchedSuccessfully(suggested: [Product])
    func productsFetchFailed(withError: Error)
}

final class BasketViewInteractor {
    weak var presenter: BasketViewInteractorOutput!
}

extension BasketViewInteractor : BasketViewInteractorProtocol {
    func fetchProducts() {
        let suggestedRequest = SuggestedProductRequest()
        var suggestedProducts: [Product] = []
        var suggestedError: Error?

        NetworkManager.shared.fetch(suggestedRequest) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    suggestedProducts = result.first?.products ?? []
                    self.presenter?.productsFetchedSuccessfully(suggested: suggestedProducts)
                case .failure(let error):
                    suggestedError = error
                    print("Failed to fetch suggested products: \(error)")
                    self.presenter?.productsFetchFailed(withError: error)
                }
            }
        }
    }
}

