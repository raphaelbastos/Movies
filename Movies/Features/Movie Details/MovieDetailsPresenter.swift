//
//  MovieDetailsPresenter.swift
//  Movies
//
//  Created by Yves Bastos on 09/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import RxSwift

class MovieDetailsPresenter {
    private var dataSource: MovieDetailsDataSource?
    private let listDataSource = MoviesListRepository()
    private weak var view: MovieDetailsViewContract?
    private var id: Int
    
    private let bag = DisposeBag()
    
    init(id: Int, view: MovieDetailsViewContract, dataSource: MovieDetailsDataSource) {
        self.id = id
        self.view = view
        self.dataSource = dataSource
    }
    
    // MARK: - Contract
    
    func onViewDidLoad() {
        loadMovieDetails()
    }
    
    // MARK: - Class
    
    private func loadMovieDetails() {
        view?.setLoadingAppearance(to: true)
        dataSource?.getMovieDetails(id: id)
            .subscribe(onNext: { [weak self] movie in
                self?.view?.setLoadingAppearance(to: false)
                self?.loadImage(path: movie.backdrop)
                if let model = self?.getViewModel(from: movie) {
                    self?.view?.updateView(with: model)
                }
                }, onError: { [weak self] error in
                    self?.view?.setLoadingAppearance(to: false)
                    self?.view?.showError(message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    private func loadImage(path: String?) {
        guard let path = path else { return }
        
        listDataSource.getImage(path: path).subscribe(onNext: { image in
            self.view?.setMovieImage(with: image)
        }, onError: { error in
            self.view?.showError(message: error.localizedDescription)
        })
        .disposed(by: bag)
    }
    
    // MARK: - Util
    
    private func getViewModel(from movie: Movie) -> MovieDetailsViewModel {
        var rating: String?
        if let movieRating = movie.rating {
            rating = "\(movieRating)"
        }
        let model = MovieDetailsViewModel(title: movie.title,
                                          tagLine: movie.tagLine,
                                          rating: rating,
                                          overview: movie.overview,
                                          releaseDate: movie.releaseDate,
                                          duration: movie.duration,
                                          genre: movie.genres?.first?.name)
        return model
    }
}
