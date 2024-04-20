//
//  ListingInteractor.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 9.04.2024.
//

import Foundation

protocol ProductListingInteractorProtocol: AnyObject {
    func fetchProducts()
    func fetchSuggestedProduct()
}

protocol ProductListingInteractorOutput: AnyObject {
    func productsFetchedSuccessfully(_ products: [Product],imageData: [ImageData])
    func suggestedProductsFetchedSuccessfully(_ products: [Product],imageData: [ImageData])
    func productsFetchFailed(withError: Error)
}

final class ProductListingInteractor {
    weak var presenter: ProductListingInteractorOutput!
}

extension ProductListingInteractor: ProductListingInteractorProtocol {
    func fetchProducts() {
        let request = ProductRequest()
        NetworkManager.shared.fetch(request) { [weak self] result in
            switch result {
            case .success(let result):
                if let products = result[0].products {
                    var imageDataArray = [ImageData]()
                    let group = DispatchGroup()
                    
                    for product in products {
                        if let url = product.imageURLAsURL {
                            var imageData = ImageData(url: url, data: nil)
                            group.enter()
                            
                            NetworkManager.shared.fetchImage(url: url) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(let data):
                                        imageData.data = data
                                        print("Fetched image for URL:", url)
                                    case .failure(let error):
                                        print("Error fetching image for URL: \(url) with error: \(error)")
                                    }
                                    imageDataArray.append(imageData)
                                    group.leave()
                                }
                            }
                        }
                    }
                    
                    group.notify(queue: .main) {
                        self?.presenter?.productsFetchedSuccessfully(products, imageData: imageDataArray)
                    }
                }
                
            case .failure(let error):
                print("Failed to fetch product: \(error)")
                self?.presenter?.productsFetchFailed(withError: error)
            }
        }
    }
    func fetchSuggestedProduct() {
        let request = SuggestedProductRequest()
        NetworkManager.shared.fetch(request) { [weak self] result in
            switch result {
            case .success(let result):
                if let firstSuggestedCategory = result.first, let products = firstSuggestedCategory.products {
                    var imageDataArray = [ImageData]()
                    let group = DispatchGroup()
                    
                    for product in products {
                        if let url = product.imageURLAsURL {
                            var imageData = ImageData(url: url, data: nil)
                            group.enter()
                            NetworkManager.shared.fetchImage(url: url) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(let data):
                                        imageData.data = data
                                        print("Fetched image for URL:", url)
                                    case .failure(let error):
                                        print("Error fetching image for URL: \(url) with error: \(error)")
                                    }
                                    imageDataArray.append(imageData)
                                    group.leave()
                                }
                            }
                        }
                    }
                    
                    group.notify(queue: .main) {
                        self?.presenter?.suggestedProductsFetchedSuccessfully(products, imageData: imageDataArray)
                    }
                }
                
            case .failure(let error):
                print("Failed to fetch suggested product: \(error)")
                self?.presenter?.productsFetchFailed(withError: error)
            }
        }
    }
    
    
}
