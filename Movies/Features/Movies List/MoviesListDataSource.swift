//
//  MoviesListDataSource.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import RxSwift

protocol MoviesListDataSource {
    func getMovies(title: String) -> Single<[Movie]>
}
