//
//  BasketCellPresenter.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 22.04.2024.
//

import Foundation

import Foundation

protocol BasketCellPresenterProtocol: AnyObject {
    func load()
}

final class BasketCellPresenter {
    weak var view: BasketCellProtocol?
    private var product: Product
    private let imageURL: URL?
    
    
    init(view: BasketCellProtocol? = nil, product: Product, imageURL: URL?) {
        self.view = view
        self.product = product
        self.imageURL = imageURL
    }
    
}
extension BasketCellPresenter: BasketCellPresenterProtocol {
 
    func load() {
        view?.setImage(from: imageURL)
        self.view?.setPriceLabel(product.price)
        self.view?.setProductNameLabel(product.name)
        self.view?.setAttributeLabel(product.attribute ?? "")
        self.view?.configureWithProductId(product.id)
    }

}
