//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import Foundation
import RxSwift

final class MovieDetailsViewModel {

    private let movieRepository: MovieRepository
    private let uiMovieDetailsMapper: UIMovieDetailsMapper
    private let disposeBag = DisposeBag()

    init(movieRepository: MovieRepository, uiMovieDetailsMapper: UIMovieDetailsMapper) {
        self.movieRepository = movieRepository
        self.uiMovieDetailsMapper = uiMovieDetailsMapper
    }

    func openMovie(with id: Int) -> Maybe<MovieDetailsUIModel> {
        movieRepository.fetchSingleMovie(with: id)
            .compactMap { movie in
                self.uiMovieDetailsMapper.mapMovieToDetailsUI(movie: movie)
            }
    }

    func changeWatchlistValue(for movieId: Int, isOnWatchlist: Bool) {
        movieRepository.changeWatchlistValue(for: movieId, isOnWatchlist: isOnWatchlist)
    }
}
