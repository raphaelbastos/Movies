//
//  MovieDetailsRepository.swift
//  Movies
//
//  Created by Yves Bastos on 09/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import RxSwift
import RxAlamofire
import Alamofire

class MovieDetailsRepository: MovieDetailsDataSource {
    
    func getMovieDetails(id: String) -> Observable<Movie> {
        let parameters = ["api_key": TMDbManager.shared.key,
                          "language": "en-US",
                          "movie_id": id]
        
        return request(.get,
                       TMDbManager.shared.movieDetailsPath,
                       parameters: parameters,
                       encoding: URLEncoding.default,
                       headers: nil)
            .responseJSON()
            .flatMap { (response) -> Observable<[Movie]> in
                switch response.result {
                case .failure(let error):
                    return Observable.error(error)
                case .success(let value):
                    guard let results = (value as? [String: Any])?["results"] as? [[String: Any]] else {
                        return Observable.empty()
                    }
                    let movies = Mapper<Movie>().mapArray(JSONArray: results)
                    return Observable.from(optional: movies)
                }
        }
    }
}
