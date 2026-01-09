//
//  FilmsView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/9/26.
//

import SwiftUI

struct FilmsView: View {
    
    @State var filmsViewModel: FilmsViewModel
    
    var body: some View {
        
        NavigationStack {
            Group {
                switch filmsViewModel.state {
                case .idle:
                    Text("No Films yet")
                case .loading:
                    ProgressView {
                        Text("Loading...")
                    }
                case .loaded(let films):
                    FilmListView(films: films)
                case .error(let error):
                    Text("Something went wrong: \n")
                    Text(error)
                        .foregroundStyle(.pink)
                }
            }
            .navigationTitle("Ghibli Movies")
        }
        .task {
            await filmsViewModel.fetch()
        }
    }
}

#Preview {
    FilmsView(filmsViewModel: FilmsViewModel(ghibliService: MockGhibliService()))
}
