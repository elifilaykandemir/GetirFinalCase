//
//  ProductCellPresenter.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 11.04.2024.
//

import Foundation

protocol ProductCellPresenterProtocol: AnyObject {
    func load()
}

final class ProductCellPresenter {
    weak var view: ProductCellProtocol?
    private var product: Product
    private let imageURL: URL?
    
    
    
    init(view: ProductCellProtocol? = nil, product: Product, imageURL: URL?) {
        self.view = view
        self.product = product
        self.imageURL = imageURL
    }
    
}
extension ProductCellPresenter: ProductCellPresenterProtocol {
 
    func load() {
        view?.setImage(from: imageURL)
        self.view?.setPriceLabel(product.price)
        self.view?.setProductNameLabel(product.name)
        self.view?.setAttributeLabel(product.attribute ?? "")
        self.view?.setProductID(product.id)

    }

}
