//
//  ListingInteractor.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 9.04.2024.
//

import Foundation

protocol ProductListingInteractorProtocol: AnyObject {
    func fetchProducts() async
    func fetchSuggestedProduct() async
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
    
    func fetchProducts() async {
        let request = ProductRequest()
        do {
            let result = try await NetworkManager.shared.fetch(request)
            if let products = result[0].products {
                var imageDataArray = [ImageData]()
                for product in products {
                    if let url = product.imageURLAsURL {
                        var imageData = ImageData(url: url, data: nil)
                        imageData.data = try? await NetworkManager.shared.fetchImage(url: url)
                        imageDataArray.append(imageData)
                        
                    }
                }
                self.presenter?.productsFetchedSuccessfully(products, imageData: imageDataArray)
            }
            
        } catch {
            print("Failed to fetch product: \(error)")
            self.presenter?.productsFetchFailed(withError: error)
        }
    }
    func fetchSuggestedProduct() async {
        let request = SuggestedProductRequest()
        do {
            let result = try await NetworkManager.shared.fetch(request)
            if let firstSuggestedCategory = result.first, let products = firstSuggestedCategory.products {
                var imageDataArray = [ImageData]()
                for product in products {
                    if let url = product.imageURLAsURL {
                        var imageData = ImageData(url: url, data: nil)
                        imageData.data = try? await NetworkManager.shared.fetchImage(url: url)
                        imageDataArray.append(imageData)
                        
                    }
                }
                self.presenter?.suggestedProductsFetchedSuccessfully(products, imageData: imageDataArray)
            }
            
        } catch {
            print("Failed to fetch product: \(error)")
            self.presenter?.productsFetchFailed(withError: error)
        }
    }
}
