//
//  DefaultFavoriteStorage.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/13/26.
//

import Foundation

class DefaultFavoriteStorage: FavoriteStorage {
    
    private let favoritesKey = "GhibliExplorer.FavoriteFilms"
    
    func load() -> Set<String> {
        let stringArray = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
        return Set(stringArray)
    }
    
    func save(favoriteIDs: Set<String>) {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: favoritesKey)
    }
    
    
}
