//
//  ListingEntity.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 9.04.2024.
//

import Foundation

struct CategoryResponse: Codable {
    let id: String
    let name: String?
    let productCount: Int?
    let products: [Product]?
    let email, password: String?
}
struct SuggestedProducts: Decodable {
    let products: [Product]?
    let id: String
    let name: String?
}

struct Product: Codable {
    let id, name: String
    let price: Double
    let priceText: String
    let imageURL, thumbnailURL: String?
    let shortDescription, category, attribute: String?
    let unitPrice: Double?
    let squareThumbnailURL: String?
    let status: Int?
    var isExpanded: Bool
    var quantity: Int
    
    var squareThumbnailASURL: URL? {
        if let urlString = squareThumbnailURL {
            return URL(string: urlString)
        }
        return nil
    }

    var imageURLAsURL: URL? {
        if let urlString = imageURL, let url = URL(string: urlString) {
            return url
        } else if let thumbnailString = squareThumbnailURL, let url = URL(string: thumbnailString) {
            return url
        }
        return nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        priceText = try container.decode(String.self, forKey: .priceText)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        thumbnailURL = try container.decodeIfPresent(String.self, forKey: .thumbnailURL)
        shortDescription = try container.decodeIfPresent(String.self, forKey: .shortDescription)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        attribute = try container.decodeIfPresent(String.self, forKey: .attribute)
        unitPrice = try container.decodeIfPresent(Double.self, forKey: .unitPrice)
        squareThumbnailURL = try container.decodeIfPresent(String.self, forKey: .squareThumbnailURL)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        isExpanded = false
        quantity = 0
    }
    init(id: String, name: String, price: Double, priceText: String, imageURL: String?, thumbnailURL: String?, shortDescription: String?, category: String?, attribute: String?, unitPrice: Double?, squareThumbnailURL: String?, status: Int?, isExpanded: Bool, quantity: Int) {
            self.id = id
            self.name = name
            self.price = price
            self.priceText = priceText
            self.imageURL = imageURL
            self.thumbnailURL = thumbnailURL
            self.shortDescription = shortDescription
            self.category = category
            self.attribute = attribute
            self.unitPrice = unitPrice
            self.squareThumbnailURL = squareThumbnailURL
            self.status = status
            self.isExpanded = isExpanded
            self.quantity = quantity
        }
}
