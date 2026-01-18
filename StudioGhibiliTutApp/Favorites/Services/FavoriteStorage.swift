//
//  FavoriteStorage.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/13/26.
//

import Foundation

protocol FavoriteStorage {
    func load() -> Set<String>
    func save(favoriteIDs: Set<String>)
}
