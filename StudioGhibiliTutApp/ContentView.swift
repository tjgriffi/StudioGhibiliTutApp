//
//  ContentView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var filmsViewModel = FilmsViewModel()
    @State private var favoritesViewModel = FavoriteViewModel()
    
    var body: some View {
        TabView {
            Tab("Films", systemImage: "movieclapper") {
                FilmsView(filmsViewModel: filmsViewModel, favoritesViewModel: favoritesViewModel)
            }
            Tab("Favorites", systemImage: "heart") {
                FavoritesView(filmsViewModel: filmsViewModel, favoritesViewModel: favoritesViewModel)
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
            Tab(role: .search) {
                SearchView(searchViewModel: SearchViewModel(), favoriteViewModel: favoritesViewModel)
            }
        }
        .task {
            favoritesViewModel.load()
            await filmsViewModel.fetch()
        }
    }
}

#Preview {
    ContentView()
}
