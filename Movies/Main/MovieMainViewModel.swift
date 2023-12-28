//
//  MovieMainViewModel.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import Foundation
import RxSwift

class MovieMainViewModel {

    private let movieRepository: MovieRepository
    private let uiMovieMapper: UIMovieMapper

    init(movieRepository: MovieRepository, uiMovieMapper: UIMovieMapper) {
        self.movieRepository = movieRepository
        self.uiMovieMapper = uiMovieMapper
    }

    func observe() -> Observable<[MovieUIModel]> {
        return movieRepository
            .observe()
            .map { movies in
                self.uiMovieMapper.mapMoviesToUI(movies: movies)
            }
            .startWith([])
    }

    func loadLocalMovies() {
        movieRepository.loadLocalMovies()
    }

    func reloadMovies(with sort: MovieSortType) {
        movieRepository.reloadMovies(with: sort)
    }
}
