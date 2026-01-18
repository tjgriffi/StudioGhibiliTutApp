//
//  SearchView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/9/26.
//

import SwiftUI

struct SearchView: View {
    
    @State private var text = ""
    @State private(set) var searchViewModel: SearchViewModel
    let favoriteViewModel: FavoriteViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                switch searchViewModel.state {
                case .idle:
                    Text("Show search here")
                case .loading:
                    ProgressView()
                case .loaded(let films):
                    FilmListView(films: films, favoritesViewModel: favoriteViewModel)
                case .error(let string):
                    Text(string)
                }
            }
                .searchable(text: $text)
                .task(id: text) {
                    
                    await searchViewModel.fetch(for: text)
                }
        }
    }
}

#Preview {
    SearchView(searchViewModel: SearchViewModel(ghibliService: MockGhibliService()), favoriteViewModel: FavoriteViewModel.preview)
}
