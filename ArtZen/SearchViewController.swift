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
    
    var stateController: StateController!
    
    private var artworks = [Artwork]()
    private let REUSE_IDENTIFIER = "imageCell"
    private var searchTerm: String? {
        return searchBar.text
    }
    private var searchIds = [Int]()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
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
    @IBAction func downloadButtonPressed(_ sender: UIBarButtonItem) {
        
        Fetcher().fetchArtwork(withId: 11790) { [weak self] artworkResult in
            switch artworkResult {
            case .success(let artwork):
                DispatchQueue.main.async {
                    self?.artworks.insert(artwork, at: 0)
                    self?.collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
                    print("yay")
                }
            case .failure(let err):
                print("\(err)")
            }
        }
    }
    
    // MARK: - Helpers
    private func getSearchResults(for searchTerm: String) {
        Fetcher().fetchObjectIds(forSearchString: searchTerm) { [weak self] objectIdsResults in
            switch objectIdsResults {
            case .success(let objectIds):
                self?.searchIds = objectIds
                if objectIds.count > 0 {
                    self?.addRandom()
                }
            case .failure(let err):
                print("\(err)")
            }
        }
    }
    
    private func addRandom() {
        let randomIndex = searchIds.randomElement()!
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
}


// MARK: - Collection View
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artworks.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let index = indexPath.row
        let url = artworks[index].smallImageURL
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, for: indexPath) as! ImageCell
        
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

// MARK: - Search Bar
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchTerm, !searchTerm.isEmpty {
            getSearchResults(for: searchTerm)
        }
        else {
            print("Nothing search term.")
        }
        view.endEditing(true)
    }
}
