//
//  DetailViewController.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/8/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var artistLabel: UILabel!
    @IBOutlet private var titleAndDateLabel: UILabel!
    @IBOutlet private var mediumLabel: UILabel!
    @IBOutlet private var dimensionsLabel: UILabel!
    @IBOutlet private var favoriteButton: UIBarButtonItem!
    
    var artwork: Artwork!
    var stateController: StateController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setFavoriteButton()
        navigationItem.title = artwork.title
        artistLabel.text = artwork.artist
        titleAndDateLabel.text = artwork.title + ", " + artwork.dateString
        mediumLabel.text = artwork.medium
        dimensionsLabel.text = artwork.dimensions
        
        Fetcher().fetchImage(url: artwork.smallImageURL) { imageResult in
            switch imageResult {
            case .success(let image):
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    // MARK: - Target-Actions
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        if stateController.isFavorite(artwork: artwork) {
            stateController.removeFromFavorites(artwork: artwork)
        }
        else {
            stateController.addToFavorites(artwork: artwork)
        }
        setFavoriteButton()
    }
    
    private func setFavoriteButton() {
        if stateController.isFavorite(artwork: artwork) {
            favoriteButton.title = "Unfavorite"
        }
        else {
            favoriteButton.title = "Favorite"
        }
    }
}
