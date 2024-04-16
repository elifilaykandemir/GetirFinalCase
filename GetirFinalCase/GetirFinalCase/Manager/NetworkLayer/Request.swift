//
//  Request.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 13.04.2024.
//

import Foundation

protocol Request {
    associatedtype Response: Decodable
    var baseUrl: String {get}
    var path: String {get}
    var method: HTTPMethod {get set}
    //var queryItems
}

enum HTTPMethod: String {
    case GET
}

extension Request {
    var asURLRequest: URLRequest {
        let url = URL.init(string: self.baseUrl + path)!
        let request = URLRequest(url: url)
        return request
    }
}
