//
//  MoviesListPresenter.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import RxSwift

class MoviesListPresenter {
    private weak var view: MoviesListViewContract?
    private var dataSource: MoviesListDataSource?
    
    private let bag = DisposeBag()
    private var movies = [Movie]()
    
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
    
    func onSearchBarEntry(text: String) {
        
    }
    
    func willDisplayCellAt(index: Int) {
        guard let path = movies[index].poster else { return }
        
        dataSource?.getImage(path: path)
            .subscribe(onNext: { [weak self] image in
                self?.view?.setCellImage(at: index, with: image)
            }, onError: { error in
                // TODO:
            })
            .disposed(by: bag)
    }
    
    private func reloadData() {
        view?.setLoadingAppearance(to: true)
        dataSource?.getLatestMovies(page: 1)
            .subscribe(onNext: { [weak self] movies in
                self?.movies = movies
                self?.view?.setLoadingAppearance(to: true)
                self?.view?.updateView(with: movies)
            }, onError: { [weak self] error in
                self?.view?.setLoadingAppearance(to: true)
                self?.view?.showError(message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
