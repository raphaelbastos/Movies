//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Yves Bastos on 09/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import UIKit

struct MovieDetailsViewModel {
    var title: String?
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
    private var movieId: Int = 0
    private var presenter: MovieDetailsPresenter!
    
    // MARK: - Lyfecicle
    init(movieId: Int) {
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
        title = model?.title
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
        svDuration.isHidden = model.duration == nil
        lbGenre.text = model.genre
        svGenre.isHidden = model.genre == nil 
    }
    
    func setLoadingAppearance(to loading: Bool) {
        if loading {
            UIView.animate(withDuration: 0.2) {
                self.loadingView.startAnimating()
                self.loadingView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.loadingView.stopAnimating()
                self.loadingView.isHidden = true
            }
        }
    }
    
    func setMovieImage(with image: UIImage) {
        imageView.image = image
    }
}
