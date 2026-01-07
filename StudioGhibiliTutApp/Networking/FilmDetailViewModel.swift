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
    
    enum State: Equatable {
        case idle
        case loading
        case loaded([Person])
        case error(String)
    }
    
    var people: [Person] = []
    var state: State = .idle
    
    let service: GhibliService
    
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    
    func fetch(for film: Film) async {
        
        guard state != .loading else { return }
        
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
}


import Playgrounds

#Playground {
    let service = MockGhibliService()
    let vm = FilmDetailViewModel(service: service)
    
    let film = service.fetchFilm()
    await vm.fetch(for: film)
    
    switch vm.state {
        case .idle:
            print("Idle")
        case .loading:
            print("loading")
        case .loaded(let people):
            for person in people {
                print(person)
            }
        case .error(let error):
            print(error)
    }
}
