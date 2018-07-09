//
//  GenreDataSource.swift
//  Movies
//
//  Created by Yves Bastos on 09/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import RxSwift

protocol GenreDataSource {
    func getGenres() -> Observable<[Genre]>
}
