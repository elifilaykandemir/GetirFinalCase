//
//  ProductCellPresenter.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 11.04.2024.
//

import Foundation

protocol ProductCellPresenterProtocol: AnyObject {
    func load()
    //func updateQuantity(with count: Int)
}

final class ProductCellPresenter {
    weak var view: ProductCellProtocol?
    private var product: Product
    private var images: ImageData
    
    
    init(view: ProductCellProtocol? = nil, product: Product, images:ImageData) {
        self.view = view
        self.product = product
        self.images = images
        
    }
    
}
extension ProductCellPresenter: ProductCellPresenterProtocol {
 
    func load() {
        view?.setStepperState(isExpanded: product.isExpanded, quantity: product.quantity)
        self.view?.setImage(images.data)
        self.view?.setPriceLabel(product.price)
        self.view?.setProductNameLabel(product.name)
        self.view?.setAttributeLabel(product.attribute ?? "")
        
    }
    
}
