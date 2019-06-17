//
//  SearchViewController.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/8/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController   {
    
    @IBOutlet private var downloadButton: UIBarButtonItem!
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var statusSpinner: UIActivityIndicatorView!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    
    var stateController: StateController!
    
    private var objectIds: ObjectIds?
    private var artworks = [Artwork]()
    private let REUSE_IDENTIFIER = "imageCell"
    private var searchBarIsEditing = false
    private var searchTerm: String? { return searchBar.text }
    private enum statusState {
        case showDefault(String)
        case showSpinning
        case showPercentage(String)
        case showNoResults(String)
    }

    private func set(statusState: statusState) {
        DispatchQueue.main.async { [weak self] in
            switch statusState {
            case .showDefault(let instructions):
                self?.statusSpinner.stopAnimating()
                self?.statusLabel.text = instructions
                self?.statusLabel.isHidden = false
            case .showSpinning:
                self?.statusSpinner.startAnimating()
                self?.statusLabel.isHidden = true
            case .showPercentage(let percentageString):
                self?.statusSpinner.stopAnimating()
                self?.statusLabel.text = percentageString
                self?.statusLabel.isHidden = false
            case .showNoResults(let noResultsString):
                self?.statusSpinner.stopAnimating()
                self?.statusLabel.text = noResultsString
                self?.statusLabel.isHidden = false
            }
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        set(statusState: .showDefault(""))
        
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
        
        set(statusState: .showSpinning)
        addRandom()
    }
    
    @IBAction func viewPressed(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Helpers
    private func getSearchResults(for searchTerm: String) {
        set(statusState: .showSpinning)
        Fetcher().fetchObjectIds(forSearchString: searchTerm) { [weak self] objectIdsResults in
            switch objectIdsResults {
            case .success(let objectIds):
                self?.objectIds = ObjectIds(todoIds: objectIds, doneIds: [])
                self?.objectIds?.delegate = self
                if objectIds.count > 0 {
                    self?.addRandom()
                }
                else {
                    self?.set(statusState: .showNoResults("No results."))
                }
            case .failure(let err):
                print("\(err)")
            }
        }
    }
    
    private func addRandom() {
        set(statusState: .showSpinning)
        
        // If there's any indexes get'em
        if let randomIndex = objectIds?.todoIds.randomElement() {
            objectIds?.finishedWith(id: randomIndex)
            Fetcher().fetchArtwork(withId: randomIndex) { [weak self] artworkResult in
                switch artworkResult {
                case .success(let artwork):
                    DispatchQueue.main.async {
                        self?.artworks.insert(artwork, at: 0)
                        self?.collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
                        self?.set(statusState: .showPercentage((self?.objectIds?.percentage.percentageViewed)!))
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
        // Stop getting them!
        else {
            set(statusState: .showPercentage((objectIds?.percentage.percentageViewed)!))
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
        
        Fetcher().fetchImage(url: url) { [weak self] imageResult in
            switch imageResult {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.setImageView(image: image)
                }
            case .failure(let error):
                print("\(error)")
            }
            self?.set(statusState: .showPercentage(((self?.objectIds?.percentage.percentageViewed)!))!)
        }
        
        return cell
    }
}

// MARK: - Search Bar
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchTerm {
            let trimmedSearchTerm = searchTerm.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedSearchTerm.isEmpty {
                artworks = []
                collectionView.reloadData()
                getSearchResults(for: searchTerm)
            }
            else {
                artworks = []
                collectionView.reloadData()
                set(statusState: .showNoResults("No results"))
            }
        }
        else {
            artworks = []
            collectionView.reloadData()
            set(statusState: .showNoResults("No results"))
        }
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarIsEditing = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarIsEditing = false
    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return searchBarIsEditing
    }
}

extension SearchViewController: ObjectIdsDelegate {
    func objectIdsDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.downloadButton.isEnabled = !(self?.objectIds?.todoIds.isEmpty)!
        }
    }
}
