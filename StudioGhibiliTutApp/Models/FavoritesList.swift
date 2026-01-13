//
//  FavoritesList.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/9/26.
//

import Foundation

class FavoritesList {
    
    static var shared: FavoritesList {
        FavoritesList()
    }
    
    static var favorites: [String] = []
    
    static func addToFavorites(filmID id: String) {
        favorites.append(id)
    }
    
    static func removeFromFavorites(filmID id: String) {
        favorites.removeAll { favoriteID in
            favoriteID == id
        }
    }
}
