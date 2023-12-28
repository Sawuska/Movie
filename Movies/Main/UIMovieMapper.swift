//
//  UIMovieMapper.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import UIKit

final class UIMovieMapper {

    func mapMoviesToUI(movies: [StoredMovie]) -> [MovieUIModel] {
        movies.map { movie in
            let image = UIImage(imageLiteralResourceName: movie.imageName ?? "")
            var yearDescription = ""
            if let date = movie.releasedDate,
               let year = Calendar.current.dateComponents([.year], from: date).year {
                yearDescription = " (\(String(year)))"
            }
            let titleWithReleaseYear = (movie.title ?? "") + yearDescription
            let duration = mapDuration(in: Int(movie.duration))
            let durationWithGenre = duration + " — " + (movie.genre ?? "")
            return MovieUIModel(
                id: Int(movie.id),
                titleWithReleaseYear: titleWithReleaseYear,
                durationWithGenre: durationWithGenre,
                showOnMyWatchList: movie.isOnWatchlist,
                image: image)
        }
    }

    private func mapDuration(in minutes: Int) -> String {
        let timeMeasure = Measurement(value: Double(minutes), unit: UnitDuration.minutes)
        let hours = timeMeasure.converted(to: .hours)
        if hours.value > 1 {
            let minutes = timeMeasure.value.truncatingRemainder(dividingBy: 60)
            return String(format: "%.f %@ %.f %@", hours.value, "h", minutes, "min")
        }
        return String(format: "%.f %@", timeMeasure.value, "min")
    }
}
