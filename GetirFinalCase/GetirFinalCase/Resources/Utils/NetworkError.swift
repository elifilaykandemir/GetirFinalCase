//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Elif İlay KANDEMİR on 5.04.2024.
//

import Foundation
enum NetworkError: String, Error {
    
    case invalidURL
    case serverError
    case invalidURLRequest
    case requestFailed
    case noConnection
    case decodingError
    
    func titleAndMessage() -> (title: String, message: String) {
        var title = ""
        var message = ""
        switch self {
        case .serverError:
            title = "Server Error"
            message = "We could not process your request. Please try again."
        case .decodingError:
            title = "Network Error"
            message = "Ensure you are connected to the internet. Please try again."
        case .invalidURL:
            title = "Invalid URL"
            message = "The request was improperly formatted."
        case .invalidURLRequest:
            title = "Invalid Request"
            message = "The request was improperly formatted."
        case .requestFailed:
            title = "Request Failed"
            message = "The request failed due to an unknown error."
        case .noConnection:
            title = "No Internet Connection"
            message = "Please check your internet connection and try again."
        
        }
        return (title: title, message: message)
    }

    var title: String {
        switch self {
        case .invalidURL:
            return NSLocalizedString("URL Error", comment: "Title for invalid URL error")
        case .serverError:
            return NSLocalizedString("Server Error", comment: "Title for server error")
        case .invalidURLRequest:
            return NSLocalizedString("Request Error", comment: "Title for invalid request error")
        case .requestFailed:
            return NSLocalizedString("Request Failed", comment: "Title for request failed error")
        case .noConnection:
            return NSLocalizedString("No Internet Connection", comment: "Title for no connection error")
        case .decodingError:
            return NSLocalizedString("Decoding Error", comment: "Title for decoding error")
        }
    }
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The URL provided was invalid.", comment: "")
        case .serverError:
            return NSLocalizedString("The server responded with an error.", comment: "")
        case .invalidURLRequest:
            return NSLocalizedString("The request was improperly formatted.", comment: "")
        case .requestFailed:
            return NSLocalizedString("The request failed due to an unknown error.", comment: "")
        case .noConnection:
            return NSLocalizedString("Please check your internet connection and try again.", comment: "")
        case .decodingError:
            return NSLocalizedString("Failed to decode the response. Please check your data.", comment: "")
        }
    }
}
