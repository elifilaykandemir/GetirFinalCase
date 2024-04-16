//
//  ListingEntity.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 9.04.2024.
//

import Foundation

//struct Product: Codable {
//    let id: String
//    let name: String
//    let attribute: String?
//    let thumbnailURL: URL
//    let imageURL: URL
//    let price: Double
//    let priceText: String
//    let shortDescription: String?
//    var quantity: Int
//}
struct CategoryResponse: Codable {
    let id: String
    let name: String?
    let productCount: Int?
    let products: [Product]?
    let email, password: String?
}
struct Product: Codable {
    let id, name: String
    let attribute: String?
    let thumbnailURL, imageURL: String
    let price: Double
    let priceText: String
    let shortDescription: String?
    var isExpanded: Bool
    var quantity: Int

    var thumbnailURLAsURL: URL? {
        URL(string: thumbnailURL)
    }

    var imageURLAsURL: URL? {
        URL(string: imageURL)
    }
    
    enum CodingKeys: String, CodingKey {
            case id, name, attribute, thumbnailURL, imageURL, price, priceText, shortDescription
           
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            attribute = try container.decodeIfPresent(String.self, forKey: .attribute)
            thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
            imageURL = try container.decode(String.self, forKey: .imageURL)
            price = try container.decode(Double.self, forKey: .price)
            priceText = try container.decode(String.self, forKey: .priceText)
            shortDescription = try container.decodeIfPresent(String.self, forKey: .shortDescription)
            isExpanded = false // Set a default value since it's not part of JSON
            quantity = 0
        }
}


struct Cart {
    var products: [Product]
    var totalAmount: Double {
        return products.reduce(0) { $0 + $1.price }
    }
}

struct ImageData {
    let url: URL
    var data: Data?
}
