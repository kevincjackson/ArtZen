//
//  StorageController.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/10/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import Foundation

class StorageController {
    
    let preSavedIdsUrl = Bundle.main.url(
        forResource: "MetAllObjectIds",
        withExtension: "archive"
    )!
    
    func load() -> WorldState {
        
        var worldState = WorldState()
        
        do {
            let preSavedIdsData = try Data(contentsOf: preSavedIdsUrl)
            let preSavedIds = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(preSavedIdsData) as! [Int]
            worldState.objectIds = preSavedIds
        }
        catch {
            print("Load error: couldn't load preSavedIds.")
        }
        return worldState
    }
}
