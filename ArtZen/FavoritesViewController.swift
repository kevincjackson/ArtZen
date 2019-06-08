//
//  FavoritesViewController.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/8/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"

class FavoritesViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
}
