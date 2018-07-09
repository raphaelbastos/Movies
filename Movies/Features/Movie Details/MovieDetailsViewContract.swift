//
//  MovieDetailsViewContract.swift
//  Movies
//
//  Created by Yves Bastos on 09/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import Foundation

protocol MovieDetailsViewContract: AnyObject {
    func showError(message: String)
    func setLoadingAppearance(to loading: Bool)
    func updateView(with model: MovieDetailsViewModel)
    func setMovieImage(with image: UIImage)
}
