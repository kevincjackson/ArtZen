//
//  MetObjects.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/11/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import Foundation

struct MetObjects: Codable {
    
    var total: Int?
    var objectIDs: [Int]?

    func toObjectIdsResults() -> ObjectIdsResults {
        if let total = total {
            if total == 0 {
                return .success([])
            }
            else {
                if let objectIds = objectIDs {
                    return .success(objectIds)
                }
                else {
                   return .failure(ObjectIdsError.missingObjectIds)
                }
            }
        }
        else {
            return .failure(ObjectIdsError.missingTotal)
        }
    }
    
}


