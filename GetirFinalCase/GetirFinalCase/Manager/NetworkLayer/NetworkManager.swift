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
                print("Decoding error: \(error)")
                if let decodingError = error as? DecodingError {
                    self.logDecodingError(decodingError)
                }
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    private func logDecodingError(_ error: DecodingError) {
        switch error {
        case .typeMismatch(let type, let context):
            print("Type mismatch: \(type) in \(context)")
        case .valueNotFound(let type, let context):
            print("Value not found: \(type), \(context.debugDescription)")
        case .keyNotFound(let key, let context):
            print("Key '\(key.stringValue)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
        case .dataCorrupted(let context):
            print("Data corrupted in \(context)")
        @unknown default:
            print("Unknown decoding error")
        }
    }
    
}
