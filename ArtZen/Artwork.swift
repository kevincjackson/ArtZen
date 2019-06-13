//
//  Artwork.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/8/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import UIKit

struct Artwork: Codable, Equatable {
    
    var identifier: Int
    var smallImageURL: URL
    var largeImageURL: URL
    var artist: String
    var title: String
    var dateString: String
    var medium: String
    var dimensions: String
    
}
