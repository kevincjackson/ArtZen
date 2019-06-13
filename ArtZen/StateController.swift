//
//  WorldStateController.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/10/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import Foundation

class StateController {
    
    private(set) var worldState: WorldState
    
    init() {
        self.worldState = StorageController().load()
    }
    
    func isFavorite(artwork: Artwork) -> Bool {
        return worldState.favorites.contains(artwork)
    }
    
    func addToFavorites(artwork: Artwork) {
        worldState.favorites.append(artwork)
    }
    
    func removeFromFavorites(artwork: Artwork) {
        if let index = worldState.favorites.firstIndex(where: { $0.identifier == artwork.identifier }) {
            worldState.favorites.remove(at: index)
        }
    }
}
