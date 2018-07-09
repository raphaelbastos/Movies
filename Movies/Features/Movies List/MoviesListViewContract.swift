//
//  MoviesListViewContract.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import Foundation
import UIKit

protocol MoviesListViewContract: AnyObject {
    func updateView(with movies: [Movie])
//    func updateView(appending latestMovies: [Movie])
    func showError(message: String)
    func setLoadingAppearance(to loading: Bool)
    func setCellImage(at index: Int, with image: UIImage)
    func showMovieDetails(id: String, model: MovieDetailsViewModel)
}
