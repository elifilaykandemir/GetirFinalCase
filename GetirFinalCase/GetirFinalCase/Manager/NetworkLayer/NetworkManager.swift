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
    
    private func secureURL(from urlString: String) -> URL? {
        if urlString.lowercased().starts(with: "http://") {
            let secureURLString = urlString.replacingOccurrences(of: "http://", with: "https://")
            return URL(string: secureURLString)
        }
        return URL(string: urlString)
    }

    func fetch<T: Request>(_ request: T, completion: @escaping (Result<T.Response, NetworkError>) -> Void) {
        guard let secureURL = secureURL(from: request.asURLRequest.url?.absoluteString ?? "") else {
                completion(.failure(.invalidURL))
                return
            }
            var secureRequest = request.asURLRequest
            secureRequest.url = secureURL

        let task = session.dataTask(with: secureRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidURL))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.Response.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let secureUrl = secureURL(from: url.absoluteString) else {
                completion(.failure(URLError(.badURL)))
                return
            }
//        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: secureUrl)) {
//            print("Returning cached data for URL:", url)
//            completion(.success(cachedResponse.data))
//            return
//        }

        let task = session.dataTask(with: secureUrl) { data, response, error in
            if let error = error {
                print("Network error occurred: \(error)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                print("HTTP response error: Not a 200 response or no data")
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            let cachedData = CachedURLResponse(response: response!, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: URLRequest(url: url))
            completion(.success(data))
        }

        task.resume()
    }
}
