//
//  MoviesListViewController.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var presenter: MoviesListPresenter!
    private var movies = [Movie]()
    private var cellSize: CGSize!
    private let numberOfColumns: CGFloat = 3
    private let collectionViewSideInsets: CGFloat = 20
    // MARK: Lyfecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
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
        title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.extendedLayoutIncludesOpaqueBars = true
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    private func setupCollectionView() {
        let availableWidth = view.frame.width
            - collectionViewSideInsets
        let width = availableWidth/numberOfColumns
        let height = width * 1.56
        cellSize = CGSize(width: width, height: height)
        
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

    // MARK: - Actions
    @objc private func didPullToRefresh() {
        // TODO:
    }
}

extension MoviesListViewController: MoviesListViewContract {
    func setCellImage(at index: Int, with image: UIImage) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: index, section: 0)
            guard let cell = self.collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell else {
                return
            }
            
            cell.setup(with: image)
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
}

extension MoviesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }
}

extension MoviesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.willDisplayCellAt(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInsets = collectionViewSideInsets/2
        return UIEdgeInsets(top: 10, left: sideInsets, bottom: 10, right: sideInsets)
    }
}
