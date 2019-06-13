//
//  MetAPI.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/4/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//
// 

import Foundation

struct MetUrls {
    
    // MARK: - URLS
    static func url(forObjectId id: Int) -> URL {
        return EndPoint.object(id).url
    }
    
    static func url(forSearchString searchString: String) -> URL {
        return EndPoint.search(searchString).url
    }
    
    // MARK: - Private
    private enum EndPoint {
        case object(Int)
        case search(String)
        
        var url: URL {
            let base = "https://collectionapi.metmuseum.org"

            switch self {
            case .object(let id):
                return URL(string: base + "/public/collection/v1/objects/" + String(id))!
            case .search(let searchString):
                return URL(string: base + "/public/collection/v1/search/?q=" + searchString)!
            }
        }
    }
}
