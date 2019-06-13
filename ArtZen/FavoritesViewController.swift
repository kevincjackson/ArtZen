//
//  FavoritesViewController.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/8/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import UIKit

class FavoritesViewController: UICollectionViewController {
    
    var stateController: StateController!
    var favorites: [Artwork] {
        return stateController.worldState.favorites
    }

    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "detailVCSegue":
            let detailVC = segue.destination as! DetailViewController
            let index = collectionView.indexPathsForSelectedItems!.first!.row
            detailVC.artwork = favorites[index]
            detailVC.stateController = stateController
        default:
            preconditionFailure("Unknown segue identifier.")
        }
    }
    
    // MARK: - Collection View
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stateController.worldState.favorites.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let index = indexPath.row
        let url = favorites[index].smallImageURL
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        
        Fetcher().fetchImage(url: url) { imageResult in
            switch imageResult {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.setImageView(image: image)
                }
            case .failure(let error):
                print("\(error)")
            }
        }
        
        return cell
    }
}
