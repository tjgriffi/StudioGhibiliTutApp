//
//  FavoritesView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/9/26.
//

import SwiftUI

struct FavoritesView: View {
    
    @State var filmsViewModel: FilmsViewModel
    
    var films: [Film] {
        // TODO: Get favorites
        // retrieve ids from storage
        // get data for favorite ids from films data
        return []
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if films.isEmpty {
                    ContentUnavailableView("No favorites yet", systemImage: "heart")
                } else {
                    List(films) { film in
                        
                        NavigationLink(value: film) {
                            HStack {
                                FilmImageView(urlString: film.image)
                                    .frame(width: 100, height: 150)
                                Text(film.title)
                            }
                            
                        }
                    }
                    .navigationDestination(for: Film.self) { film in
                        FilmDetailView(film: film)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView(filmsViewModel: FilmsViewModel(ghibliService: MockGhibliService()))
}
