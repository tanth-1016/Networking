//
//  APIError.swift
//  RX_Networking
//
//  Created by Luong Manh on 15/12/2023.
//


import Foundation

public enum APIError: Error {
    case hostError(description: String)
    case badStatusCode(code: Int, description: String)
    case networkError(description: String)
    case decodingError(description: String)
    case encodingError(description: String)
    case failure(description: String)
//    case decodedError(error: Any)
    case missingURL
    case invalidURL
    case failedMetadata
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .hostError(let description):
            return "Please check your host «\(description)"
        case .badStatusCode(let code, let description):
            return "Did receive bad status code=\(code) with description «\(description)»"
        case .networkError(let description):
//            return "Network failure with description «\(description)»"
            return "Something wrong with your connection. Please try again later!"
        case .decodingError(let description):
            return "Decoding failure with description «\(description)»"
        case .failure(let description):
            return "Did failed with description «\(description)»"
//        case .decodedError(let model):
//            return "Decode error for model «\(model)»"
        case .missingURL:
            return "Missing URL."
        case .invalidURL:
            return "Invalid URL."
        case .encodingError(description: let description):
            return "Encoding failure with description «\(description)»"
        case .failedMetadata:
            return "Sign in failed due to a network error. Please check your internet connection and try again."
        }
    }
}
