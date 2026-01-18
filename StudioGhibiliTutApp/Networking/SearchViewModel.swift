//
//  SearchViewModel.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/15/26.
//

import Foundation

@Observable
class SearchViewModel {
    var state: LoadingState<[Film]> = .idle
    
    private let service: GhibliService
    private var currentSearchTerm: String = ""
    
    init(ghibliService: GhibliService = DefaultGhibliService()) {
        self.service = ghibliService
    }
    
    func fetch(for searchTerm: String) async {
        
        self.currentSearchTerm = searchTerm
        
        guard !searchTerm.isEmpty else {
            self.state = .idle
            return
        }
        
        // MARK: Together these two lines of code form a debounce
        // Add a buffer so we don't throttle our searching
        // This also accounts for a user not "finishing" their
        // prompt
        try? await Task.sleep(for: .milliseconds(500))
        
        // Check that the task was not cancelled
        guard !Task.isCancelled else { return }
        
        state = .loading
        do {
            let films = try await service.searchFilm(for: searchTerm)
            state = .loaded(films)
        } catch {
            setError(error, for: searchTerm)
        }
//        } catch let error as APIError {
//            state = .error(error.errorDescription ?? "unknown APIError")
//        } catch let error as CancellationError {
//            if currentSearchTerm == searchTerm {
//                self.state = .idle
//            }
//        } catch {
//            state = .error("unknown error")
//        }
    }
    
    func setError(_ error: Error, for searchTerm: String) {
    
        guard currentSearchTerm == searchTerm else { return }
        
        if let error = error as? APIError {
            self.state = .error(error.errorDescription ?? "unknown error")
        } else {
            self.state = .error("unknown error")
        }
    }
}
