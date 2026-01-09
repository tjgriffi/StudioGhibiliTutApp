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
//        MockGhibliService().fetchFilm()
        let bannerURL = URL.convertAssetImage(named: "CastleInTheSkyBanner")
        let listURL = URL.convertAssetImage(named: "CastleInTheSkyList")
        
        return Film(
            id: "id",
            title: "My Neighbor Totoro",
            description: "Two sisters move to the country with their father in order to be closer to their hospitalized mother, and discover the surrounding trees are inhabited by Totoros, magical spirits of the forest. When the youngest runs away from home, the older sister seeks help from the spirits to find her.",
            director: "Hayao Miyazaki",
            producer: "Hayao Miyazaki",
            image: listURL?.absoluteString ?? "",
            bannerImage: bannerURL?.absoluteString ?? "",
            people: [
                "https://ghibliapi.vercel.app/people/986faac6-67e3-4fb8-a9ee-bad077c2e7fe",
                "https://ghibliapi.vercel.app/people/d5df3c04-f355-4038-833c-83bd3502b6b9",
                "https://ghibliapi.vercel.app/people/3031caa8-eb1a-41c6-ab93-dd091b541e11",
                "https://ghibliapi.vercel.app/people/87b68b97-3774-495b-bf80-495a5f3e672d",
                "https://ghibliapi.vercel.app/people/d39deecb-2bd0-4770-8b45-485f26e1381f",
                "https://ghibliapi.vercel.app/people/591524bc-04fe-4e60-8d61-2425e42ffb2a",
                "https://ghibliapi.vercel.app/people/c491755a-407d-4d6e-b58a-240ec78b5061",
                "https://ghibliapi.vercel.app/people/f467e18e-3694-409f-bdb3-be891ade1106",
                "https://ghibliapi.vercel.app/people/08ffbce4-7f94-476a-95bc-76d3c3969c19",
                "https://ghibliapi.vercel.app/people/0f8ef701-b4c7-4f15-bd15-368c7fe38d0a"
            ],
            releaseYear: "1988",
            duration: "86",
            score: "93")
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
