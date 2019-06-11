//
//  MetAPI.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/4/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import Foundation

struct MetAPI {
    
//    static func fetchObject(id: Int, handler: @escaping (ObjectResult) -> Void) {
    static func fetchObject(id: Int) {
        let url = EndPoint.object(id).url
        print(url)
    }
    
    enum ObjectResult {
        case success(MetObject)
        case failure(String)
    }
    
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
