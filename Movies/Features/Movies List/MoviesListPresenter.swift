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
    private var currentPage = 1
    private var isLoading = false
    
    init(view: MoviesListViewContract, dataSource: MoviesListDataSource) {
        self.view = view
        self.dataSource = dataSource
    }
 
    // MARK: - Class Methods
    func onViewDidLoad() {
        loadUpcomingMovies()
    }
    
    func onPullToRefresh() {
        resetData()
        loadUpcomingMovies()
    }
    
    func onSearchBarEntry(text: String) {
        guard text.count > 0 else {
            resetData()
            loadUpcomingMovies()
            return
        }
        
        dataSource?.searchMovie(title: text, page: 1)
            .subscribe(onNext: { [weak self] searchedMovies in
                self?.movies = searchedMovies
                self?.view?.updateView(with: searchedMovies)
            }, onError: { [weak self] error in
                self?.view?.showError(message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    func onSearchCancel() {
        resetData()
        loadUpcomingMovies()
    }
    
    func getCellModel(at index: Int) -> MovieCellViewModel {
        let movie = movies[index]
        let model = MovieCellViewModel(title: movie.title ?? "?", genre: nil/*movie.gender*/, year: movie.releaseDate)
        return model
    }
    
    func willDisplayCellAt(index: Int) {
        guard let path = movies[index].poster else { return }
        
        dataSource?.getImage(path: path)
            .subscribe(onNext: { [weak self] image in
                self?.view?.setCellImage(at: index, with: image)
            }, onError: { _ in
                // TODO:
            })
            .disposed(by: bag)
    }
    
    func paginate() {
        loadUpcomingMovies()
    }
    
    private func loadUpcomingMovies() {
        guard !isLoading else { return }
        
        isLoading = true
        view?.setLoadingAppearance(to: true)
        dataSource?.getUpcomingMovies(page: currentPage)
            .subscribe(onNext: { [weak self] movies in
                self?.isLoading = false
                self?.movies.append(contentsOf: movies)
                self?.view?.setLoadingAppearance(to: true)
                self?.view?.updateView(with: movies)//self?.movies ?? [])
                self?.currentPage += 1
            }, onError: { [weak self] error in
                self?.isLoading = false
                self?.view?.setLoadingAppearance(to: true)
                self?.view?.showError(message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    // MARK: - Util
    private func resetData() {
        view?.updateView(with: [])
        movies = []
        currentPage = 1
    }
}
