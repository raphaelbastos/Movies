//
//  MoviesListDataSource.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import RxSwift
import UIKit

protocol MoviesListDataSource {
    func getLatestMovies(page: Int) -> Observable<[Movie]>
    func searchMovie(title: String, page: Int) -> Observable<[Movie]>
    func getImage(path: String) -> Observable<UIImage>
}
