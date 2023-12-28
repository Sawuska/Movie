//
//  MovieMainViewController.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import UIKit
import RxSwift
import RxCocoa

class MovieMainViewController: UIViewController {

    private let contentView = MovieMainView()
    private let disposeBag = DisposeBag()

    private let movieMainViewModel: MovieMainViewModel

    init(movieMainViewModel: MovieMainViewModel) {
        self.movieMainViewModel = movieMainViewModel
        super.init(nibName: nil, bundle: nil)
        movieMainViewModel.loadLocalMovies()
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

        setUpNavigationBar()
        contentView.moviesTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        setTableViewObservers()
    }

    private func setUpNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Movies"
        navigationController?.navigationBar.tintColor = .label
        let rightButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(onSortButtonTap))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = rightButton
    }

    @objc private func onSortButtonTap() {
        let alert = setUpActionSheetController()
        present(alert, animated: true)
    }

    private func setUpActionSheetController() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .label
        alert.addAction(
            UIAlertAction(
                title: "Title",
                style: .default,
                handler:{ [weak self] _ in
                    self?.movieMainViewModel.reloadMovies(with: .title)
                }))
        alert.addAction(
            UIAlertAction(
                title: "Released Date",
                style: .default,
                handler:{ [weak self] _ in
                    self?.movieMainViewModel.reloadMovies(with: .releasedDate)
                }))
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler:{ _ in
                    alert.dismiss(animated: true)
                }))
        return alert
    }

    private func setTableViewObservers() {
        contentView.moviesTableView.dataSource = nil
        movieMainViewModel.observe()
            .observe(on: MainScheduler.instance)
            .do(onNext: updateViewVisibility)
            .bind(to: contentView.moviesTableView.rx.items) { tableView, index, item in
                self.dequeueMovieCell(tableView: tableView, at: index, with: item)
            }
            .disposed(by: self.disposeBag)

        contentView.moviesTableView.rx.modelSelected(MovieUIModel.self)
            .bind(onNext: { uiModel in
                self.selectedCell(with: uiModel)
            })
            .disposed(by: disposeBag)
    }

    private func updateViewVisibility(with movies: [MovieUIModel]) {
        movies.isEmpty ? contentView.showLoading() : contentView.hideLoading()
    }

    private func dequeueMovieCell(
        tableView: UITableView,
        at index: Int,
        with item: MovieUIModel
    ) -> UITableViewCell {
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieCell",
            for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        cell.updateInfo(movie: item)
        return cell
    }

    private func selectedCell(with uiModel: MovieUIModel) {
        let vc = Dependencies.shared.movieDetailsViewController(movieId: uiModel.id)
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MovieMainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        MovieCell.getCellHeight(for: tableView.bounds.width)
    }
}

