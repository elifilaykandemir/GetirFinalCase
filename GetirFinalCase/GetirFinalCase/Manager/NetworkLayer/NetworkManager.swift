//
//  NetworkManager.swift
//  GetirFinalCase
//
//  Created by Elif İlay KANDEMİR on 13.04.2024.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let decoder = JSONDecoder()
    
    private init() {}
   

    func fetch<T: Request>(_ request: T, completion: @escaping (Result<T.Response, NetworkError>) -> Void) {

        let task = URLSession.shared.dataTask(with: request.asURLRequest) { data, response, error in
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

}
