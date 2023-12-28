//
//  StoredMovieMapper.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import CoreData

final class StoredMovieMapper {

    func mapFetchResultsToStoredMovieList(results: [NSFetchRequestResult?]) -> [StoredMovie] {
        results.compactMap { $0 as? StoredMovie }
    }
}
