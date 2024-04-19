//
//  ProductDetailInteractor.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 18.04.2024.
//

import Foundation

protocol ProductDetailInteractorProtocol: AnyObject {
    func takeProductID()
}

protocol ProductDetailInteractorOutput: AnyObject {
    func productsPassed()
    
}

final class ProductDetailInteractor {
    weak var presenter: ProductDetailInteractorOutput!
   
}

extension ProductDetailInteractor: ProductDetailInteractorProtocol {
    func takeProductID() {
        
    }
}
