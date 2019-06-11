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
    
    // MARK: - Target-Actions
    @IBAction func browseButtonPressed(_ sender: UIBarButtonItem) {
        let randomInt = stateController.worldState.objectIds.randomElement()!
        MetAPI.fetchObject(id: randomInt)
        
    }
    
    
    // MARK: - Collection View Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artworks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, for: indexPath)
        
        return cell
    }
}
