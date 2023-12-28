//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import UIKit
import RxSwift

class MovieDetailsViewController: UIViewController {

    private let contentView = MovieDetailsView()
    private let disposeBag = DisposeBag()

    private let movieId: Int
    private let viewModel: MovieDetailsViewModel

    private var trailerURL: URL?

    init(viewModel: MovieDetailsViewModel, movieId: Int) {
        self.viewModel = viewModel
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.addSubview(contentView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.openMovie(with: movieId)
            .subscribe(onSuccess: { uiModel in
                self.contentView.update(with: uiModel)
                self.trailerURL = uiModel.trailerURL
            })
        .disposed(by: disposeBag)

        addButtonActions()
    }

    private func addButtonActions() {
        contentView.watchlistButton.addTarget(self, action: #selector(watchlistButtonSelected), for: .touchUpInside)
        contentView.watchTrailerButton.addTarget(self, action: #selector(watchTrailerButtonTapped), for: .touchUpInside)
    }

    @objc
    private func watchlistButtonSelected(_ button: UIButton) {
        button.isSelected.toggle()
        viewModel.changeWatchlistValue(for: movieId, isOnWatchlist: button.isSelected)
    }

    @objc
    private func watchTrailerButtonTapped() {
        guard let url = trailerURL else { return }
        let vc = WebVideoViewController(trailerUrl: url)
        navigationController?.pushViewController(vc, animated: true)
    }

}
