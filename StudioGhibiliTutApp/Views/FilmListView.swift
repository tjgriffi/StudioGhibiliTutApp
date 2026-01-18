//
//  FilmListView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import SwiftUI

struct FilmListView: View {
    
//    var filmsViewModel: FilmsViewModel
    var films: [Film]
    let favoritesViewModel: FavoriteViewModel
//    @State private var favorites: [String] = FavoritesList.favorites
    
    var body: some View {
        
        List(films) { film in
            
            NavigationLink(value: film) {
                FilmRow(film: film, favoritesViewModel: favoritesViewModel)
            }
        }
        .navigationDestination(for: Film.self) { film in
            FilmDetailView(film: film, favoritesViewModel: favoritesViewModel)
        }
    }
}

private struct FilmRow: View {
    let film: Film
    let favoritesViewModel: FavoriteViewModel
    var isFavorite: Bool {
        favoritesViewModel.isFavorite(filmID: film.id)
    }
    
    var body: some View {
        HStack(alignment: .top) {
            FilmImageView(urlString: film.image)
                .frame(width: 100, height: 150)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(film.title)
                        .bold()
                    
                    Spacer()
                    
                    FavoriteButton(filmID: film.id, favoritesViewModel: favoritesViewModel)
                        .buttonStyle(.plain)
                        .controlSize(.large)
                }
                .padding(.bottom, 5)
                
                Text("Directed by \(film.director)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Released: \(film.releaseYear)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 5)
        }
    }
}

#Preview {
//    @State @Previewable var viewModel = FilmsViewModel(ghibliService: MockGhibliService())
    @State @Previewable var favoriteViewModel = FavoriteViewModel(favoriteStorage: MockFavoriteStorage())
    
    NavigationStack {
        FilmListView(films: [Film.preview, Film.previewFavorite], favoritesViewModel: favoriteViewModel)
    }
        .task {
            favoriteViewModel.load()
        }
}
