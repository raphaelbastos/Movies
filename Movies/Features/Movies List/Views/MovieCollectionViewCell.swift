//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import UIKit
import Reusable

struct MovieCellViewModel {
    var title: String
    var genre: String?
    var year: String?
}

class MovieCollectionViewCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbGenre: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
    }

    func setup(with model: MovieCellViewModel) {
        lbTitle.text = model.title
        lbGenre.text = model.genre
        lbYear.text = model.year
        
        lbTitle.isHidden = true // Hiding because it looks better
                                // and seems unnecessary with the poster being shown 
        lbGenre.isHidden = model.genre == nil
        lbYear.isHidden = model.year == nil
    }
    
    func setImage(_ image: UIImage) {
        movieImageView.image = image
    }
}
