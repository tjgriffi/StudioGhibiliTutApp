//
//  APIError.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decoding(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        
        switch self {
        case .invalidURL:
            return "The URL is invalid"
        case .invalidResponse:
            return "The HTTPresponse is invalid"
        case .decoding(let error):
            return "There was a decoding error: \(error.localizedDescription)"
        case .networkError(let error):
            return "There was a network error: \(error.localizedDescription)"
        }
    }
}
