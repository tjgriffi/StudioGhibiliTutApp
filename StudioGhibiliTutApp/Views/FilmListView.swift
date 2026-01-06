//
//  FilmListView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import SwiftUI

struct FilmListView: View {
    
    @State var filmsViewModel = FilmsViewModel()
    
    var body: some View {
        
        Group {
            switch filmsViewModel.state {
            case .idle:
                Text("No Films yet")
            case .loading:
                ProgressView {
                    Text("Loading...")
                }
            case .loaded(let films):
                List(films) { film in
                    
                    Text(film.title)
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
    FilmListView()
}
