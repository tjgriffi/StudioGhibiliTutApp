//
//  FilmDetailViewModel.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import Foundation
import Observation

@Observable
class FilmDetailViewModel {
    
    var people: [Person] = []
    var state: LoadingState<[Person]> = .idle
    var favorited = false
    
    let service: GhibliService
    
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    
    func fetch(for film: Film) async {
        
        guard !state.isLoading else { return }
        
        state = .loading
        var loadedPeople = [Person]()
        
        do {
            
            try await withThrowingTaskGroup(of: Person.self) { group in
                
                for personInfoURL in film.people {
                    group.addTask {
                        try await self.service.fetchPerson(from: personInfoURL)
                    }
                }
                
                // Collect the results as they complete
                for try await person in group {
                    loadedPeople.append(person)
                }
                
                
                state = .loaded(loadedPeople)
                people = loadedPeople
            }
            
        } catch let error as APIError {
            state = .error(error.errorDescription ?? "unknown APIError")
        } catch {
            state = .error("unknown error")
        }
    }
    
    func favoriteButtonPressed(filmID: String) {
        
        // Toggle favorite
        favorited.toggle()
        
//        if favorited {
//            // Update our list of favorited movies
//            FavoritesList.shared.addToFavorites(filmID: filmID)
//        } else {
//            FavoritesList.shared.removeFromFavorites(filmID: filmID)
//        }
        
        favorited ? FavoritesList.addToFavorites(filmID: filmID) : FavoritesList.removeFromFavorites(filmID: filmID)
        print(filmID)
        print(FavoritesList.favorites)
    }
}


import Playgrounds

//#Playground {
//    let service = MockGhibliService()
//    let vm = FilmDetailViewModel(service: service)
//    
//    let film = service.fetchFilm()
//    await vm.fetch(for: film)
//    
//    switch vm.state {
//        case .idle:
//            print("Idle")
//        case .loading:
//            print("loading")
//        case .loaded(let people):
//            for person in people {
//                print(person)
//            }
//        case .error(let error):
//            print(error)
//    }
//}
