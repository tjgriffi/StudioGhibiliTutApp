//
//  FilmListView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import SwiftUI

struct FilmListView: View {
    
    var filmsViewModel: FilmsViewModel
    
    var body: some View {
        
        NavigationStack {
            switch filmsViewModel.state {
            case .idle:
                Text("No Films yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let films):
                List(films) { film in
                    
                    NavigationLink(value: film) {
                        Text(film.title)
                    }
                }
                .navigationDestination(for: Film.self) { film in
                    FilmDetailView(film: film)
                }
            case .error(let error):
                Text("Something went wrong: \n")
                Text(error)
                    .foregroundStyle(.pink)
            }
        }
        .task {
            await filmsViewModel.fetch()
        }
        
    }
}

#Preview {
    @State @Previewable var viewModel = FilmsViewModel(ghibliService: MockGhibliService())
    
    FilmListView(filmsViewModel: viewModel)
}
