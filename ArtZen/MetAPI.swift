//
//  MetAPI.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/4/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import Foundation

struct MetAPI {
    
    static private let baseURLString = "https://collectionapi.metmuseum.org/"
    
    private enum EndPoint {
        case object(Int)
        case search(String)
        
        var path: String {
            switch self {
            case .object:
                return "/public/collection/v1/objects/"
            case .search:
                return "/public/collection/v1/search/?q="
            }
        }
    }
    
    func fetchObject(withId id: Int) -> URL {
        
        return URL(string: "")!
    }
}
