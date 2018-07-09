//
//  MoviesListPresenter.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import RxSwift

class MoviesListPresenter {
    private var view: MoviesListViewContract?
    private var dataSource: MoviesListDataSource?
    
    private let bag = DisposeBag()
    
    init(view: MoviesListViewContract, dataSource: MoviesListDataSource) {
        self.view = view
        self.dataSource = dataSource
    }
 
    // MARK: - Class Methods
    func onViewDidLoad() {
        reloadData()
    }
    
    func onPullToRefresh() {
        reloadData()
    }
    
    private func reloadData() {
        view?.setLoadingAppearance(to: true)
        dataSource?.getLatestMovies(page: 1)
            .subscribe(onNext: { movies in
                self.view?.setLoadingAppearance(to: true)
                self.view?.updateView(with: movies)
            }, onError: { error in
                self.view?.setLoadingAppearance(to: true)
                self.view?.showError(message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
