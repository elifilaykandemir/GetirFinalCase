//
//  ProductRequest.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 13.04.2024.
//

import Foundation

typealias ProductResponse = [CategoryResponse]

struct ProductRequest: Request {
    var baseUrl: String = "https://65c38b5339055e7482c12050.mockapi.io/api"
    typealias Response = ProductResponse
    let path: String = "/products"
    var method: HTTPMethod = .GET
    
}
