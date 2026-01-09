//
//  ContentView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import SwiftUI

struct ContentView: View {
    
    @State var filmsViewModel = FilmsViewModel(ghibliService: MockGhibliService())
    
    var body: some View {
        TabView {
            Tab("Films", systemImage: "movieclapper") {
                FilmsView(filmsViewModel: filmsViewModel)
            }
            Tab("Favorites", systemImage: "heart") {
                FavoritesView(filmsViewModel: filmsViewModel)
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
            Tab(role: .search) {
                SearchView()
            }
            
        }
    }
}

#Preview {
    ContentView()
}
