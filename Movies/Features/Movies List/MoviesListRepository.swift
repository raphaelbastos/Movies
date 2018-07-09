//
//  MoviesListRepository.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire
import ObjectMapper

class MoviesListRepository: MoviesListDataSource {
    private let cache = NSCache<NSString, UIImage>()

    func getLatestMovies(page: Int) -> Observable<[Movie]> {
        let parameters = ["api_key": TMDbManager.key,
                          "language": "en-US",
                          "page": "\(page)"]

        return request(.get,
                       TMDbManager.upcomingMoviesPath,
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
    
//    func getImage(path: String) -> Single<UIImage> {
//        
//    }
}
