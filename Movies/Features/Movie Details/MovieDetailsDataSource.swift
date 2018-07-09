//
//  MovieDetailsDataSource.swift
//  Movies
//
//  Created by Yves Bastos on 09/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import RxSwift

protocol MovieDetailsDataSource: AnyObject {
    func getMovieDetails(id: Int) -> Observable<Movie>
}
