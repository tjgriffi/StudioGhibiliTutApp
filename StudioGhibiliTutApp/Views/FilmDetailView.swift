//
//  FilmDetailView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/6/26.
//

import SwiftUI

struct FilmDetailView: View {
    
    let film: Film
    let favoritesViewModel: FavoriteViewModel
    
    @State private var filmDetailViewModel = FilmDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
//                HStack(alignment: .center) {
//                    Text(film.title)
//                        .bold()
//                    
//                        Button {
//                            filmDetailViewModel.favoriteButtonPressed(filmID: film.id)
//                        } label: {
//                            if filmDetailViewModel.favorited {
//                                Image(systemName: "heart.fill")
//                                    .foregroundStyle(.pink)
//                            } else {
//                                Image(systemName: "heart")
//                                    .foregroundStyle(.black)
//                            }
//                        }
//
//                }
                FilmImageView(urlString: film.bannerImage)
                    .frame(height: 300)
                
                
                Text(film.title)
                Divider()
                Text("Characters: ")
                    .font(.title3)
                
                switch filmDetailViewModel.state {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .loaded(let people):
                    ForEach(people) { person in
                        Text(person.name)
                    }
                case .error(let error):
                    Text(error)
                }
                
                
            }
            .padding()
        }
        .toolbar {
            FavoriteButton(filmID: film.id, favoritesViewModel: favoritesViewModel)
        }
        .task(id: film) {
            await filmDetailViewModel.fetch(for: film)
        }
    }
}



#Preview {
    NavigationStack {
        FilmDetailView(film: Film.preview, favoritesViewModel: FavoriteViewModel(favoriteStorage: MockFavoriteStorage()))
    }
}
