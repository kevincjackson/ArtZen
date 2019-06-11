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
}
