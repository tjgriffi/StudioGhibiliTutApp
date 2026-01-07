//
//  MockGhibliService.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import Foundation

struct MockGhibliService: GhibliService {
    
    struct SampleData: Codable {
        let films: [Film]
        let people: [Person]
    }
    
    var data: SampleData?
    
    private func loadData() throws -> SampleData {
        
        guard let url = Bundle.main.url(forResource: "SampleData", withExtension: "json") else {
            throw APIError.invalidURL
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            return try JSONDecoder().decode(SampleData.self, from: data)
        } catch let error as DecodingError {
            throw APIError.decoding(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func fetchFilms() async throws -> [Film] {
        
        let data = try loadData()
    
        return data.films
    }
    
    func fetchPerson(from URLString: String) async throws -> Person {
        
        let data = try loadData()
    
        return data.people.first!
    }
    
    // MARK: - Preview/Testing only
    func fetchFilm() -> Film {
        
        let data = try! loadData()
                
        return data.films.first!
    }
    
}
