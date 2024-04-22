//
//  ListingInteractor.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 9.04.2024.
//

import Foundation

protocol ProductListingInteractorProtocol: AnyObject {
    func fetchProducts()
}

protocol ProductListingInteractorOutput: AnyObject {
    func productsFetchedSuccessfully(_ products: (regular: [Product], suggested: [Product]))
    func productsFetchFailed(withError: Error)
}

final class ProductListingInteractor {
    weak var presenter: ProductListingInteractorOutput!
}

extension ProductListingInteractor: ProductListingInteractorProtocol {

    func fetchProducts() {
            let regularRequest = ProductRequest()
            let suggestedRequest = SuggestedProductRequest()
            let group = DispatchGroup()

            var regularProducts: [Product] = []
            var suggestedProducts: [Product] = []
            var regularError: Error?
            var suggestedError: Error?

            group.enter()
            NetworkManager.shared.fetch(regularRequest) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let result):
                        regularProducts = result.first?.products ?? []
                    case .failure(let error):
                        regularError = error
                        print("Failed to fetch regular products: \(error)")
                    }
                    group.leave()
                }
            }

            group.enter()
            NetworkManager.shared.fetch(suggestedRequest) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let result):
                        suggestedProducts = result.first?.products ?? []
                    case .failure(let error):
                        suggestedError = error
                        print("Failed to fetch suggested products: \(error)")
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                if let error = regularError {
                    self.presenter?.productsFetchFailed(withError: error)
                } else if let error = suggestedError {
                    self.presenter?.productsFetchFailed(withError: error)
                } else {
                    self.presenter?.productsFetchedSuccessfully((regular: regularProducts, suggested: suggestedProducts))
                }
            }
        }
}
