//
//  MoviesListRepository.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import RxSwift

class MoviesListRepository: MoviesListDataSource {
    func getMovies(title: String) -> Single<[Movie]> {
        // TODO:
        return Single.just([])
    }
}
