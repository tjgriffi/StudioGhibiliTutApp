//
//  FilmListView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/5/26.
//

import SwiftUI

struct FilmListView: View {
    
//    var filmsViewModel: FilmsViewModel
    @State var films: [Film]
    
    var body: some View {
        
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

//#Preview {
//    @State @Previewable var viewModel = FilmsViewModel(ghibliService: MockGhibliService())
//    
//    FilmListView(films: viewModel.films)
//}
