//
//  MoviesListViewController.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var presenter: MoviesListPresenter!
    private var movies = [Movie]()
    private let bag = DisposeBag()
    
    private var cellSize: CGSize!
    private let numberOfColumns: CGFloat = 2
    private let collectionViewSideInsets: CGFloat = 20
    // MARK: Lyfecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearch()
        observeSearchBar()
        setupCollectionView()
        setupPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    private func setupPresenter() {
        presenter = MoviesListPresenter(view: self, dataSource: MoviesListRepository())
        presenter.onViewDidLoad()
    }

    private func setupNavigationBar() {
        title = "Upcoming Movies"
        self.extendedLayoutIncludesOpaqueBars = true
    }

    private func setupCollectionView() {
        let movieTextHeight: CGFloat = 55
        let availableWidth = view.frame.width
            - collectionViewSideInsets
        let width = availableWidth/numberOfColumns
        let height = width * 1.56 + movieTextHeight
        cellSize = CGSize(width: width, height: height)
        
        // TODO: reactivate.
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self,
//                                 action: #selector(didPullToRefresh),
//                                 for: .valueChanged)
//        collectionView.refreshControl = refreshControl
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: MovieCollectionViewCell.self)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = flowLayout
    }
    
    private func setupSearch() {
        searchController.searchBar.placeholder = "Search the entire database"
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.isActive = true
        navigationItem.searchController = searchController
    }
    
    private func observeSearchBar() {
        searchController.searchBar.rx
            .text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ (text) -> Bool in
                return !text.isEmpty
            })
            .subscribe(onNext: { [weak self] text in
                self?.presenter.onSearchBarEntry(text: text)
            })
            .disposed(by: bag)
        
        searchController.searchBar.rx
            .cancelButtonClicked
            .asObservable()
            .subscribe(onNext: { _ in
                self.presenter.onSearchCancel()
            })
            .disposed(by: bag)
    }

    // MARK: - Actions
    @objc private func didPullToRefresh() {
        presenter.onPullToRefresh()
    }
}

extension MoviesListViewController: MoviesListViewContract {
    func setCellImage(at index: Int, with image: UIImage) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: index, section: 0)
            guard let cell = self.collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell else {
                return
            }
            
            cell.setImage(image)
        }
    }
    
    func setLoadingAppearance(to loading: Bool) {
        if loading {
            collectionView.showRefreshControl()
        } else {
            collectionView.hideRefreshControl()
        }
    }
    
    func updateView(with movies: [Movie]) {
        self.movies = movies
        collectionView.reloadData()
    }
    
    func showError(message: String) {
        let errorAlertController = UIAlertController(title: "Oops, an error occured", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        errorAlertController.addAction(okAction)
        present(errorAlertController, animated: true, completion: nil)
    }
    
    func showMovieDetails(id: String, model: MovieDetailsViewModel){
        let detailsViewController = MovieDetailsViewController()
        detailsViewController.model = model
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension MoviesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let model = presenter.getCellModel(at: indexPath.item)
        cell.setup(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.onItemSelection(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endOfScrollView = (scrollView.contentSize.height - scrollView.contentOffset.y - view.frame.height) < 30
        
        if endOfScrollView {
            presenter.paginate()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        
        let endOfScrollView = (scrollView.contentSize.height - scrollView.contentOffset.y - view.frame.height) < 30

        if endOfScrollView {
            presenter.paginate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        presenter.willDisplayCellAt(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInsets = collectionViewSideInsets/2
        return UIEdgeInsets(top: 10, left: sideInsets, bottom: 10, right: sideInsets)
    }
}
