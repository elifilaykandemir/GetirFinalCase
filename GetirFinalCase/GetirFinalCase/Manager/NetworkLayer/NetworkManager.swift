//
//  NetworkManager.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 13.04.2024.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 100 * 1024 * 1024,
                                          diskCapacity: 100 * 1024 * 1024,
                                          diskPath: "imageCache")
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: configuration)
    }()
    private let decoder = JSONDecoder()
    
    private init() {}
    
    func fetch<T: Request>(_ request: T) async throws -> T.Response {
        print("Sending request to URL: \(request.asURLRequest.url?.absoluteString ?? "Invalid URL")")
        
        do {
            let (data, _) = try await session.data(for: request.asURLRequest)
            return try decoder.decode(T.Response.self, from: data)
        } catch {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.invalidURL
        }
    }
    func fetchImage(url: URL) async throws -> Data? {
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return cachedResponse.data
        } else {
            let (data, response) = try await URLSession.shared.data(from: url)
            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: URLRequest(url: url))
            return data
        }
    }

}
