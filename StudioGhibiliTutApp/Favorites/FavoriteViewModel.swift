//
//  FavoriteViewModel.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/13/26.
//

import Foundation
import Observation

@Observable
class FavoriteViewModel {
    
    private(set) var favoriteIDs: Set<String> = []
    private let favoriteStorage: FavoriteStorage
    
    init(favoriteStorage: FavoriteStorage = DefaultFavoriteStorage()) {
        self.favoriteStorage = favoriteStorage
    }
   
    func load() {
        favoriteIDs = favoriteStorage.load()
    }
    
    private func save() {
        favoriteStorage.save(favoriteIDs: favoriteIDs)
    }
    
    func toggleFavorite(filmID: String) {
        if favoriteIDs.contains(filmID) {
            favoriteIDs.remove(filmID)
        } else {
            favoriteIDs.insert(filmID)
        }
        
        save()
    }
    
    func isFavorite(filmID: String) -> Bool {
        favoriteIDs.contains(filmID)
    }
    
    // MARK: - Preview
    static var preview: FavoriteViewModel {
        let vm = FavoriteViewModel(favoriteStorage: MockFavoriteStorage())
        vm.favoriteIDs = ["2baf70d1-42bb-4437-b551-e5fed5a87abe"]
        return vm
    }
}
