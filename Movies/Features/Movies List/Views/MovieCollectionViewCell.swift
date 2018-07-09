//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import UIKit
import Reusable

class MovieCollectionViewCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
    }

    func setup(with image: UIImage) {
        movieImageView.image = image
    }
}
