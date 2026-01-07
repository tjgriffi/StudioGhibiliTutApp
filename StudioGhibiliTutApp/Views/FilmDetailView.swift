//
//  FilmDetailView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/6/26.
//

import SwiftUI

struct FilmDetailView: View {
    
    let film: Film
    @State private var filmDetailViewModel = FilmDetailViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            
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
        .task {
            await filmDetailViewModel.fetch(for: film)
        }
    }
}

#Preview {
    FilmDetailView(film: Film.preview )
}
