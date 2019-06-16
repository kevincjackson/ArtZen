//
//  ExploreViewController.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/8/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import UIKit


class ExplorationViewController: UICollectionViewController {
    
    var stateController: StateController!
    private var artworks = [Artwork]()
    private let REUSE_IDENTIFIER = "imageCell"

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "detailVCSegue":
            let detailVC = segue.destination as! DetailViewController
            let index = collectionView.indexPathsForSelectedItems!.first!.row
            detailVC.artwork = artworks[index]
            detailVC.stateController = stateController
        default:
            preconditionFailure("Unknown segue identifier.")
        }
    }
    
    // MARK: - Target-Actions
    @IBAction func browseButtonPressed(_ sender: UIBarButtonItem) {
        for _ in 0..<3 {
            addRandom()
        }
    }
    
    // MARK: - Helpers
    private func addRandom() {
        let randomIndex = stateController.worldState.objectIds.randomElement()!
        Fetcher().fetchArtwork(withId: randomIndex) { [weak self] artworkResult in
            switch artworkResult {
            case .success(let artwork):
                DispatchQueue.main.async {
                    self?.artworks.insert(artwork, at: 0)
                    self?.collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
                }
            case .failure(let err):
                switch err {
                case ArtworkError.notInPublicDomain:
                    self?.addRandom()
                default:
                    print("\(err)")
                    
                }
            }
        }
    }
    
    // MARK: - Collection View Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artworks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let index = indexPath.row
        let url = artworks[index].smallImageURL
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, for: indexPath) as! ImageCell
        
        Fetcher().fetchImage(url: url) { imageResult in
            switch imageResult {
            case .success(let image):
                DispatchQueue.main.async {
                    print(url)
                    print(self.artworks[index].smallImageURL)
                    print(url == self.artworks[index].smallImageURL)
                    cell.setImageView(image: image)
                }
            case .failure(let error):
                print("\(error)")
            }
        }
        
        return cell
    }
}
