//
//  MovieMainView.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import UIKit

class MovieMainView: UIView {

    private static let fontSize: CGFloat = 24

    let moviesTableView: UITableView = {
        @UseAutoLayout var view = UITableView(frame: .zero)
        view.backgroundColor = .systemBackground
        view.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        view.showsVerticalScrollIndicator = false
        return view
    }()

    private let loadingView: UIActivityIndicatorView = {
        @UseAutoLayout var view = UIActivityIndicatorView(style: .large)
        view.backgroundColor = .systemBackground
        view.hidesWhenStopped = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        [moviesTableView, loadingView].forEach(addSubview(_:))
        backgroundColor = .systemBackground
        useAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.constraintFrameToMatchParent(child: self, parent: self.superview)
        NSLayoutConstraint.activate([
            moviesTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            moviesTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            moviesTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            moviesTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        NSLayoutConstraint.constraintFrameToMatchParent(child: loadingView, parent: moviesTableView)
    }

    func showLoading() {
        loadingView.isHidden = false
        loadingView.startAnimating()
    }

    func hideLoading() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
    }

}
