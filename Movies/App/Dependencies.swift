//
//  Dependencies.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import Foundation
import CoreData

final class Dependencies {
    static let shared = Dependencies()

    private let movieRepository: MovieRepository

    private init() {
        let managedObjContext = AppDelegate().persistentContainer.viewContext
        movieRepository = MovieRepository(
            managedObjContext: managedObjContext,
            storedMovieMapper: StoredMovieMapper(),
            jsonMapper: JSONMapper<LocalMovies>())
    }

    func movieMainViewController() -> MovieMainViewController {
        return MovieMainViewController(
            movieMainViewModel: MovieMainViewModel(
                movieRepository: movieRepository,
                uiMovieMapper: UIMovieMapper()
            )
        )
    }

    func movieDetailsViewController(movieId: Int) -> MovieDetailsViewController {
        return MovieDetailsViewController(
            viewModel: MovieDetailsViewModel(
                movieRepository: movieRepository,
                uiMovieDetailsMapper: UIMovieDetailsMapper()),
            movieId: movieId)
    }
}
