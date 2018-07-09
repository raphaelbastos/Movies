//
//  MovieDetailsPresenter.swift
//  Movies
//
//  Created by Yves Bastos on 09/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import RxSwift

class MovieDetailsPresenter {
    private weak var dataSource: MovieDetailsDataSource?
    private weak var view: MovieDetailsViewContract?
    private var id: String
    
    private let bag = DisposeBag()
    
    init(id: String, view: MovieDetailsViewContract, dataSource: MovieDetailsDataSource) {
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
                let model = self?.getViewModel(from: movie)
                self?.view?.updateView(with: model)
                }, onError: { [weak self] error in
                    self?.view?.setLoadingAppearance(to: false)
                    self?.view?.showError(message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    // MARK: - Util
    
    private func getViewModel(from movie: Movie) -> MovieDetailsViewModel {
        let model = MovieDetailsViewModel(tagLine: <#T##String?#>,
                                          rating: <#T##String?#>,
                                          overview: <#T##String?#>,
                                          releaseDate: <#T##String?#>,
                                          duration: <#T##String?#>,
                                          genre: <#T##String?#>)
        return model
    }
}
