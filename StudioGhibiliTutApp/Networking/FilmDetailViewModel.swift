//
//  FilmDetailViewModel.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import Foundation
import Observation

class FilmDetailViewModel {
    
    var people: [Person] = []
    
    let service: GhibliService
    
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    
    func fetch(for film: Film) async {
        
        do {
            
            try await withThrowingTaskGroup(of: Person.self) { group in
                
                for personInfoURL in film.people {
                    group.addTask {
                        try await self.service.fetchPerson(from: personInfoURL)
                    }
                }
                
                // Collect the results as they complete
                for try await person in group {
                    people.append(person)
                }
            }
            
        } catch {
            
        }
    }
}
