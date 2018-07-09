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
    private let genreDataSource = GenreRepository()
    
    private let bag = DisposeBag()
    private var movies = [Movie]()
    private var genresById = [Int: Genre]()
    private var currentPage = 1
    private var isLoading = false
    
    init(view: MoviesListViewContract, dataSource: MoviesListDataSource) {
        self.view = view
        self.dataSource = dataSource
    }
 
    // MARK: - Contract
    func onViewDidLoad() {
        initialFetch()
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
    
    func onItemSelection(at index: Int) {
        guard let movieId = movies[index].id else { return }
        view?.showMovieDetails(id: movieId, model: getMovieDetailsModel(index: index))
    }
    
    func onSearchCancel() {
        resetData()
        loadUpcomingMovies()
    }
    
    func getCellModel(at index: Int) -> MovieCellViewModel {
        let movie = movies[index]
        var genre: Genre?
        
        if let mainGenreId = movie.genreIds?.first {
            genre = genresById[mainGenreId]
        }
        
        var yearString: String?
        if let year = movie.releaseDate?.split(separator: "-").first {
            yearString = String(year)
        }
        
        let model = MovieCellViewModel(title: movie.title ?? "?", genre: genre?.name, year: yearString)
        return model
    }
    
    func willDisplayCellAt(index: Int) {
        guard let path = movies[index].poster else { return }
        
        dataSource?.getImage(path: path)
            .subscribe(onNext: { [weak self] image in
                self?.view?.setCellImage(at: index, with: image)
            }, onError: { _ in
                // TODO: add placeholder image
            })
            .disposed(by: bag)
    }
    
    func paginate() {
        loadUpcomingMovies()
    }
    
    // MARK: - Class Methods
    private func initialFetch() {
        guard !isLoading, let dataSource = dataSource else { return }
        
        isLoading = true
        view?.setLoadingAppearance(to: true)
        
        let upcomingObservable: Observable<[Movie]> = dataSource.getUpcomingMovies(page: currentPage)
        let genreObservable: Observable<[Genre]> = genreDataSource.getGenres()
        
        Observable.zip(upcomingObservable,
                       genreObservable,
                       resultSelector: { return ($0, $1) })
            .subscribe(onNext: { [weak self] (movies, genres) in
                self?.isLoading = false
                
                genres.forEach { genre in
                    if let id = genre.id {
                        self?.genresById[id] = genre
                    }
                }
                
                self?.movies.append(contentsOf: movies)
                self?.view?.setLoadingAppearance(to: true)
                self?.view?.updateView(with: self?.movies ?? [])
                self?.currentPage += 1
                }, onError: { [weak self] error in
                    self?.isLoading = false
                    self?.view?.setLoadingAppearance(to: true)
                    self?.view?.showError(message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    private func getMovieDetailsModel(index: Int) -> MovieDetailsViewModel {
        let movie = movies[index]
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
    
    private func loadUpcomingMovies() {
        guard !isLoading else { return }
        
        isLoading = true
        view?.setLoadingAppearance(to: true)
        dataSource?.getUpcomingMovies(page: currentPage)
            .subscribe(onNext: { [weak self] movies in
                self?.isLoading = false
                self?.movies.append(contentsOf: movies)
                self?.view?.setLoadingAppearance(to: true)
                self?.view?.updateView(with: self?.movies ?? [])
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
