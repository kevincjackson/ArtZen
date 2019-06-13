//
//  ImageCell.swift
//  ArtZen
//
//  Created by Kevin Jackson on 6/12/19.
//  Copyright © 2019 Kevin Jackson. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    // Automates spinner
    func setImageView(image: UIImage?) {
        if let image = image {
            spinner.stopAnimating()
            imageView.image = image
        }
        else {
            imageView.image = image
            spinner.startAnimating()
        }
    }
    
    // Automates spinner
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setImageView(image: nil)
    }
    
    // Automates spinner
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setImageView(image: nil)
    }
}
