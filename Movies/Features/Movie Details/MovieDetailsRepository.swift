//
//  MovieDetailsRepository.swift
//  Movies
//
//  Created by Yves Bastos on 09/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire
import ObjectMapper

class MovieDetailsRepository: MovieDetailsDataSource {
    
    func getMovieDetails(id: Int) -> Observable<Movie> {
        let parameters: [String: Any] = ["api_key": TMDbManager.shared.key,
                                         "language": "en-US"]
        let url = "\(TMDbManager.shared.movieDetailsPath)/\(id)"
        return request(.get,
                       url,
                       parameters: parameters,
                       encoding: URLEncoding.default,
                       headers: nil)
            .responseJSON()
            .flatMap({ response -> Observable<Movie> in
                switch response.result {
                case .failure(let error):
                    return Observable.error(error)
                case .success(let value):
                    guard let result = value as? [String: Any] else {
                        return Observable.empty()
                    }
                    let movie = Mapper<Movie>().map(JSON: result)
                    return Observable.from(optional: movie)
                }
            })
    }
}
