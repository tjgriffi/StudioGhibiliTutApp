//
//  FavoriteButton.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/15/26.
//


import SwiftUI

struct FavoriteButton: View {
    let filmID: String
    let favoritesViewModel: FavoriteViewModel
    
    var isFavorite: Bool {
        favoritesViewModel.isFavorite(filmID: filmID)
    }
    
    var body: some View {
        Button {
            favoritesViewModel.toggleFavorite(filmID: filmID)
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(isFavorite ? .pink : .gray )
        }
    }
}
