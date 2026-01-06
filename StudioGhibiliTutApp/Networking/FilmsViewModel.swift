//
//  FilmsViewModel.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import Foundation
import Observation

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

@Observable
class FilmsViewModel {
    
    enum State: Equatable {
        case idle
        case loading
        case loaded([Film])
        case error(String)
    }
    
    var state = State.idle
    var films: [Film] = []
    
    func fetch() async {
        
        guard state == .idle else {
            return
        }
        state = .loading
        do {
            let films = try await fetchFilms()
            state = .loaded(films)
        } catch let error as APIError {
            state = .error(error.errorDescription ?? "unknown APIError")
        } catch {
            state = .error("unknown error")
        }
    }
    
    private func fetchFilms() async throws -> [Film] {
        
        guard let url = URL(string: "https://ghibliapi.vercel.app/films") else {
            throw APIError.invalidURL
        }
        
        do {
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            return try JSONDecoder().decode([Film].self, from: data)
        } catch let error as DecodingError {
            throw APIError.decoding(error)
        } catch let error as URLError {
            throw APIError.networkError(error)
        }
    }
}
