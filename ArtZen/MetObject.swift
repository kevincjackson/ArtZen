//
//  MetObject.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/11/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import Foundation

struct MetObject: Codable {
    
    var objectID: Int
    var isPublicDomain: Bool
    var primaryImage: String?
    var primaryImageSmall: String?
    var title: String?
    var artistDisplayName: String?
    var objectDate: String?
    var medium: String?
    var dimensions: String?
    
}
