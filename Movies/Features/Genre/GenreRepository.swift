//
//  GenreRepository.swift
//  Movies
//
//  Created by Yves Bastos on 09/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import RxSwift
import RxAlamofire
import Alamofire
import ObjectMapper

class GenreRepository: GenreDataSource {
    func getGenres() -> Observable<[Genre]> {
        let parameters: [String: Any] = ["api_key": TMDbManager.shared.key,
                          "language": "en-US"]
        return request(.get,
                       TMDbManager.shared.genresPath,
                       parameters: parameters,
                       encoding: URLEncoding.default,
                       headers: nil)
            .responseJSON()
            .flatMap { (response) -> Observable<[Genre]> in
                switch response.result {
                case .failure(let error):
                    return Observable.error(error)
                case .success(let value):
                    guard let results = (value as? [String: Any])?["genres"] as? [[String: Any]] else {
                        return Observable.empty()
                    }
                    let genres = Mapper<Genre>().mapArray(JSONArray: results)
                    return Observable.from(optional: genres)
                }
        }
    }
}
