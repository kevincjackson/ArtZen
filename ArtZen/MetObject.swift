//
//  MetObject.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/11/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import Foundation

struct MetObject: Codable {
    
    var objectID: Int?
    var isPublicDomain: Bool?
    var primaryImage: String?
    var primaryImageSmall: String?
    var title: String?
    var artistDisplayName: String?
    var objectDate: String?
    var medium: String?
    var dimensions: String?
    
    func toArtworkResult() -> ArtworkResult {
        
        guard let localObjectID = objectID
        else {
            return .failure(ArtworkError.missingId)
        }
        
        guard let localIsPublicDomain = isPublicDomain
        else {
            return .failure(ArtworkError.missingIsPublicDomain)
        }
        
        guard localIsPublicDomain
        else {
            return .failure(ArtworkError.notInPublicDomain)
        }
        
        guard let localSmallImage = primaryImageSmall, !localSmallImage.isEmpty
        else {
            return .failure(ArtworkError.missingImage)
        }
        
        // Some URLs have spaces at the end.
        let localSmallImageEncoded = localSmallImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let smallImageUrl = URL(string: localSmallImageEncoded) else {
            return .failure(ArtworkError.badURL)
        }
        
        var localLargeImage: String
        if let primaryImage = primaryImage {
            if !primaryImage.isEmpty {
                localLargeImage = primaryImage
            }
            else {
                localLargeImage = localSmallImage
            }
        }
        else {
            localLargeImage = localSmallImage
        }
        
        // Some URLs have spaces at the end.
        let localLargeImageEncoded = localLargeImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        guard let largeImageUrl = URL(string: localLargeImageEncoded) else {
            return .failure(ArtworkError.badURL)
        }
        
        var localArtist: String
        if let artistDisplayName = artistDisplayName, !artistDisplayName.isEmpty {
            localArtist = artistDisplayName
        }
        else {
            localArtist = "Unknown Artist"
        }
        
        var localTitle: String
        if let title = title, !title.isEmpty {
            localTitle = title
        }
        else {
            localTitle = "Unknown Title"
        }
        
        var localDateString: String
        if let objectDate = objectDate, !objectDate.isEmpty {
            localDateString = objectDate
        }
        else {
            localDateString = "Unknown Date"
        }
        
        var localMedium: String
        if let medium = medium, !medium.isEmpty {
            localMedium = medium
        }
        else {
            localMedium = "Unknown Medium"
        }
        
        var localDimensions: String
        if let dimensions = dimensions, !dimensions.isEmpty {
            localDimensions = dimensions
        }
        else {
            localDimensions = "Unknown Dimensions"
        }
        
        return .success(Artwork(
            identifier: localObjectID,
            smallImageURL: smallImageUrl,
            largeImageURL: largeImageUrl,
            artist: localArtist,
            title: localTitle,
            dateString: localDateString,
            medium: localMedium,
            dimensions: localDimensions
        ))
    }
}
