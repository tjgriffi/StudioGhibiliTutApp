//
//  FavoritesView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/9/26.
//

import SwiftUI

struct FavoritesView: View {
    
    let filmsViewModel: FilmsViewModel
    let favoritesViewModel: FavoriteViewModel
    
    var films: [Film] {
        // TODO: Get favorites
        // retrieve ids from storage
        // get data for favorite ids from films data
        let favorites = favoritesViewModel.favoriteIDs
        switch filmsViewModel.state {
        case .loaded(let films):
            return films.filter { film in
                favorites.contains(film.id)
            }
        default:
            return []
        }
        
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if films.isEmpty {
                    ContentUnavailableView("No favorites yet", systemImage: "heart")
                } else {
                    FilmListView(films: films, favoritesViewModel: favoritesViewModel)
                        .navigationDestination(for: Film.self) { film in
                            FilmDetailView(film: film, favoritesViewModel: favoritesViewModel)
                        }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView(filmsViewModel: FilmsViewModel.preview, favoritesViewModel: FavoriteViewModel.preview)
}
