//
//  SearchViewController.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/8/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    
    private let REUSE_IDENTIFIER = "imageCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
    }

}

// MARK: - Collection View
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, for: indexPath)
        
        return cell
    }
}

// MARK: - Search Bar
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("TODO")
    }
}
