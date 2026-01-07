//
//  FilmsViewModel.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import Foundation
import Observation

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
    
    private let service: GhibliService
    
    init(ghibliService: GhibliService = DefaultGhibliService()) {
        self.service = ghibliService
    }
    
    func fetch() async {
        
        guard state == .idle else {
            return
        }
        state = .loading
        do {
            let films = try await service.fetchFilms()
            state = .loaded(films)
        } catch let error as APIError {
            state = .error(error.errorDescription ?? "unknown APIError")
        } catch {
            state = .error("unknown error")
        }
    }
}
