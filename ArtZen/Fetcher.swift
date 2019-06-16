//
//  Downloader.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/11/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import UIKit

struct Fetcher {
    
    private static var session = URLSession.shared
    
    func fetchArtwork(withId id: Int, completionHandler: @escaping (ArtworkResult) -> Void) {
        
        let url = URLRequest(url: MetUrls.url(forObjectId: id))
        let task = Fetcher.session.dataTask(with: url) { (data, response, error) in
            
            var artworkResult: ArtworkResult
            
            if let json = data {
                let metObject = try! JSONDecoder().decode(MetObject.self, from: json)
                artworkResult = metObject.toArtworkResult()
            }
            else {
               artworkResult = .failure(error!)
            }
            completionHandler(artworkResult)
        }
        task.resume()
    
        
    }
    
    func fetchImage(url: URL, completionHandler: @escaping (ImageResult) -> Void) {
        
        let task = Fetcher.session.dataTask(with: url) { (data, response, error) in
    
            var imageResult: ImageResult
            
            if let data = data {
                if let image = UIImage(data: data) {
                    imageResult = .success(image)
                }
                else {
                    imageResult = .failure(ImageError.creationError)
                }
            }
            else {
                imageResult = .failure(error!)
            }
     
            completionHandler(imageResult)
        }
        task.resume()
    }
    
    func fetchObjectIds(forSearchString searchString: String, completionHandler: @escaping (ObjectIdsResults) -> Void) {
        
        let url = URLRequest(url: MetUrls.url(forSearchString: searchString))
        let task = Fetcher.session.dataTask(with: url) { (data, response, error) in
            
            if let json = data {
                do {
                    let metObjects = try JSONDecoder().decode(
                        MetObjects.self,
                        from: json)
                    let objectIdsResults = metObjects.toObjectIdsResults()
                    completionHandler(objectIdsResults)
                }
                catch {
                    completionHandler(.failure(ObjectIdsError.JSONError))
                }
            }
            else {
                completionHandler(.failure(ObjectIdsError.retrievalError))
            }
        }
        task.resume()
    }
}

enum ArtworkResult {
    case success(Artwork)
    case failure(Error)
}

enum ArtworkError: Error {
    case badURL
    case missingId
    case missingIsPublicDomain
    case missingImage
    case notInPublicDomain
}

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum ImageError: Error {
    case creationError
}

enum ObjectIdsResults {
    case success([Int])
    case failure(Error)
}

enum ObjectIdsError: Error {
    case JSONError
    case missingTotal
    case missingObjectIds
    case retrievalError
}
