//
//  MetAPI.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/4/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import Foundation

struct MetAPI {
    
    // MARK: - Public API
    enum FetchArtworksResult {
        case success([Artwork])
        case failure(Error)
    }
    
    static func fetchRandomArtworks(amount: Int = 12) -> FetchArtworksResult {
        
        let artworks = [Artwork]()
        
//        while artworks.count < amount {
//            let randomId = Int.random(in: 0..<MetAPI.object_ids.count)
//            let randomObjectId = MetAPI.object_ids[randomId]
//            let artwork = fetchArtwork(withId: randomObjectId)
//            artworks.append(artwork)
//        }
//
        return .success(artworks)
    }
    
    static func fetchArtworks(usingSearchString searchString: String) -> FetchArtworksResult {
        return .success([])
    }
    
    // /////////////////////////////////////////////////////////////////////////
    // MARK: - Private
    // /////////////////////////////////////////////////////////////////////////

    private enum MetAPIError: Error {
        case allObjectsError(String)
    }
    
    static private var object_ids = [Int]()

    static func fetchAllObjectsIds() {
        let url = URL(string: MetAPI.baseURLString + EndPoint.all_objects.path)!
        
        let task = URLSession(configuration: URLSessionConfiguration.default)
            .dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("\(error)")
            }
    
            if let json = data {
                do {
                    let allObjectsReponse = try JSONDecoder().decode(AllObjectsResponse.self, from: json)
                    let ids = allObjectsReponse.objectIDs
                    
                    let data = try NSKeyedArchiver.archivedData(withRootObject: ids, requiringSecureCoding: false)
                    
                    let storageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MetAllObjectIds.archive")
                    try data.write(to: storageURL)
                    print(storageURL)
                }
                catch {
                    print("JSON decoding failed.")
                }
            }
        }
        task.resume()
    }
    
    func fetchArtwork(withId id: Int) -> Artwork {
        
        return Artwork(smallImageURL: URL(string: "")!, largeImageURL: nil, artist: "", title: "", dateString: "", medium: "", dimensions: "")
    }
    
    
    static private let baseURLString = "https://collectionapi.metmuseum.org"
    
    private enum EndPoint {
        case all_objects
        case object(Int)
        case search(String)
        
        var path: String {
            switch self {
            case .all_objects:
                return "/public/collection/v1/objects"
            case .object:
                return "/public/collection/v1/objects/"
            case .search:
                return "/public/collection/v1/search/?q="
            }
        }
    }
    
    private struct AllObjectsResponse: Decodable {
        var total: Int
        var objectIDs: [Int]
    }
}
