//
//  MovieRepository.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import Foundation
import RxSwift
import CoreData

final class MovieRepository {

    private let sortSubject = BehaviorSubject<MovieSortType>(value: .title)
    private let notifyChangesSubject = BehaviorSubject<Void>(value: ())
    private let disposeBag = DisposeBag()
    private let managedObjContext: NSManagedObjectContext
    private let storedMovieMapper: StoredMovieMapper
    private let jsonMapper: JSONMapper<LocalMovies>

    init(managedObjContext: NSManagedObjectContext,
         storedMovieMapper: StoredMovieMapper,
         jsonMapper: JSONMapper<LocalMovies>
    ) {
        self.jsonMapper = jsonMapper
        self.managedObjContext = managedObjContext
        self.storedMovieMapper = storedMovieMapper
    }

    func observe() -> Observable<[StoredMovie]> {
        notifyChangesSubject.withLatestFrom(sortSubject)
            .flatMap { sort in
                self.fetchFromCoreData(with: sort)
            }
    }

    func loadLocalMovies() {
        let path = Bundle.main.path(forResource: "movies", ofType: "json") ?? ""
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let localMovies = jsonMapper.mapData(data)
            guard let movies = localMovies?.movies else {
                return
            }
            cacheMovies(movies: movies)
            reloadMovies(with: .title)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func reloadMovies(with sort: MovieSortType) {
        sortSubject.on(.next(sort))
    }

    func changeWatchlistValue(for movieId: Int, isOnWatchlist: Bool) {
        fetchSingleMovie(with: movieId)
            .subscribe { result in
                if let movie = try? result.get() {
                    movie.isOnWatchlist = isOnWatchlist
                }
                do {
                    try self.managedObjContext.save()
                } catch let error {
                    print(error.localizedDescription)
                }
                self.notifyChangesSubject.on(.next(()))
            }.disposed(by: disposeBag)
    }

    func fetchSingleMovie(with id: Int) -> Single<StoredMovie?> {
        Single<StoredMovie?>.create { single in
            if let entityDescription =
                NSEntityDescription.entity(forEntityName: "StoredMovie",
                                           in: self.managedObjContext),
               let request = StoredMovie.fetchRequest() as?
                NSFetchRequest<NSFetchRequestResult> {
                request.entity = entityDescription
                let predicate = NSPredicate(format: "ANY id = %i", id)
                request.predicate = predicate

                do {
                    let results = try self.managedObjContext.fetch(request).first
                    let fetchedMovie = self.storedMovieMapper
                        .mapFetchResultsToStoredMovieList(results: [results]).first
                    single(.success(fetchedMovie))
                } catch let error {
                    print(error.localizedDescription)
                    single(.failure(error))
                }
            } else {
                single(.success(nil))
            }

            return Disposables.create {
            }
        }
    }

    private func fetchFromCoreData(with sort: MovieSortType) -> Observable<[StoredMovie]> {
        return Observable<[StoredMovie]>.create { observable in
            guard let entityDescription =
                  NSEntityDescription.entity(forEntityName: "StoredMovie",
                                             in: self.managedObjContext),
                  let request = StoredMovie.fetchRequest() as?
                          NSFetchRequest<NSFetchRequestResult> else {
                observable.onCompleted()
                return Disposables.create {}
            }
            request.entity = entityDescription

            let sortDecriptor = NSSortDescriptor(key: sort.rawValue, ascending: true)
            request.sortDescriptors = [sortDecriptor]
            do {
                let results = try self.managedObjContext.fetch(request)
                let fetchedMovies = self.storedMovieMapper
                    .mapFetchResultsToStoredMovieList(results: results)
                observable.onNext(fetchedMovies)
            } catch let error {
                print(error.localizedDescription)
                observable.onError(error)
            }
            return Disposables.create {}
        }
    }

    private func cacheMovies(movies: [Movie]) {
        guard let movieEntityDescription =
            NSEntityDescription.entity(forEntityName: "StoredMovie",
                                       in: managedObjContext) else { return }
        for (index, movie) in movies.enumerated() {
            let movieEntity = StoredMovie(
                entity: movieEntityDescription,
                insertInto: managedObjContext)
            movieEntity.id = Int64(index)
            movieEntity.title = movie.title
            movieEntity.overview = movie.description
            movieEntity.rating = movie.rating
            movieEntity.duration = Int64(movie.duration)
            movieEntity.genre = movie.genre
            movieEntity.releasedDate = movie.releasedDate
            movieEntity.trailerLink = movie.trailerLink
            movieEntity.imageName = movie.imageName
        }
        do {
            try managedObjContext.save()
        } catch let error as NSError {
            guard let conflicts = error.userInfo["conflictList"] as? [NSConstraintConflict] else {
                print(error.localizedDescription)
                return
            }
            handleConflicts(conflicts)
            do {
                try managedObjContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    private func handleConflicts(_ conflicts: [NSConstraintConflict]) {
        for conflict in conflicts {
            guard let conflictingObjects = conflict.conflictingObjects as? [StoredMovie] else {
                return
            }
            conflictingObjects.forEach { managedObjContext.delete($0) }
        }
    }

}
