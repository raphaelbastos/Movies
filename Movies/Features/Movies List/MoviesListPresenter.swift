//
//  MoviesListPresenter.swift
//  Movies
//
//  Created by Yves Bastos on 08/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import Foundation

class MoviesListPresenter {
    private var view: MoviesListViewContract?
    private var dataSource: MoviesListDataSource?
    
    init(view: MoviesListViewContract, dataSource: MoviesListDataSource) {
        self.view = view
        self.dataSource = dataSource
    }
 
    // MARK: - Class Methods
    func onViewDidLoad() {
        view?.setLoadingAppearance(to: true)
    }
}
