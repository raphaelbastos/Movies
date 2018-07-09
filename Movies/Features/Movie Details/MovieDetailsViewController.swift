//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Yves Bastos on 09/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import UIKit

struct MovieDetailsViewModel {
    var tagLine: String?
    var rating: String?
    var overview: String?
    var releaseDate: String?
    var duration: String?
    var genre: String?
}

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbTagline: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var lbOverview: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbGenre: UILabel!
    @IBOutlet weak var svRelease: UIStackView!
    @IBOutlet weak var svDuration: UIStackView!
    @IBOutlet weak var svGenre: UIStackView!
    
    var model: MovieDetailsViewModel?
    private var movieId: String = ""
    private var presenter: MovieDetailsPresenter!
    
    // MARK: - Lyfecicle
    init(movieId: String) {
        super.init(nibName: "MovieDetailsViewController", bundle: nil)
        self.movieId = movieId
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = model {
            updateView(with: model)
        }
        setupPresenter()
    }
    
    private func setupPresenter() {
        presenter = MovieDetailsPresenter(id: movieId, view: self, dataSource: MovieDetailsRepository())
        presenter.onViewDidLoad()
    }
}

extension MovieDetailsViewController: MovieDetailsViewContract {
    func showError(message: String) {
        let errorAlertController = UIAlertController(title: "Oops, an error occured", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        errorAlertController.addAction(okAction)
        present(errorAlertController, animated: true, completion: nil)
    }
    
    func updateView(with model: MovieDetailsViewModel) {
        lbTagline.text = model.tagLine
        lbTagline.isHidden = model.tagLine == nil
        lbRating.text = model.rating ?? "?"
        
        lbOverview.text = model.overview ?? "No overview available"
        lbReleaseDate.text = model.releaseDate
        svRelease.isHidden = model.releaseDate == nil
        lbDuration.text = model.duration
        lbDuration.isHidden = model.duration == nil
        lbGenre.text = model.genre
        lbGenre.isHidden = model.genre == nil 
    }
    
    func setLoadingAppearance(to loading: Bool) {
        if loading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
    
    func setMovieImage(with image: UIImage) {
        imageView.image = image
    }
}
