//
//  TMDbManager.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

struct TMDbManager {
    static let shared = TMDbManager()
    
    let key = "1f54bd990f1cdfb230adb312546d765d"
    let movieSearchPath = "https://api.themoviedb.org/3/search/movie"
    let upcomingMoviesPath = "https://api.themoviedb.org/3/movie/upcoming"
    let movieDetailsPath = "https://api.themoviedb.org/3/movie"
    let configurationUrl = "https://api.themoviedb.org/3/configuration"
    let genresPath = "https://api.themoviedb.org/3/genre/movie/list"
    
    private let bag = DisposeBag()
    
    func getConfiguration() {
        let parameters: [String: Any] = ["api_key": key]
        
        request(.get,
                configurationUrl,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: nil)
            .responseJSON()
            .subscribe(onNext: { response in
                switch response.result {
                case .success(let value):
                    if let value = value as? [String: Any],
                        let images = value["images"] as? [String: Any],
                        let imagesBaseUrl = images["secure_base_url"] as? String {
                        UserDefaults.standard.setValue(imagesBaseUrl, forKey: "imagesBaseUrl")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
}
