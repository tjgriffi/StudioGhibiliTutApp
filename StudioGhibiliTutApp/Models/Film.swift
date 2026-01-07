//
//  Film.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import Foundation

struct Film: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let description: String
    let director: String
    let producer: String
    
    let image: String
    let bannerImage: String
    let people: [String]
    
    let releaseYear: String
    let duration: String
    let score: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, image, description, director, producer, people
        
        case bannerImage = "movie_banner"
        case releaseYear = "release_date"
        case duration = "running_time"
        case score = "rt_score"
    }
    
    static var preview: Film {
        return MockGhibliService().fetchFilm()
    }
}

import Playgrounds

#Playground {
    
    let url = URL(string: "https://ghibliapi.vercel.app/films")!
    
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let films = try JSONDecoder().decode([Film].self, from: data)
    } catch {
        print(error)
    }
}
