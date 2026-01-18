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
    
    var state: LoadingState<[Film]> = .idle
    
    private let service: GhibliService
    
    init(ghibliService: GhibliService = DefaultGhibliService()) {
        self.service = ghibliService
    }
    
    func fetch() async {
        
        guard !state.isLoading || state.error != nil else {
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
    
    // MARK: - Testing purposes only!
    static var preview: FilmsViewModel {
        let vm = FilmsViewModel(ghibliService: MockGhibliService())
        let loadedFilms = [Film.preview, Film.previewFavorite]
        vm.state = .loaded(loadedFilms)
        return vm
    }
}
