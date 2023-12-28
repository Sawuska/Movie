//
//  UIMovieDetailsMapper.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import UIKit

final class UIMovieDetailsMapper {

    func mapMovieToDetailsUI(movie: StoredMovie?) -> MovieDetailsUIModel? {
        guard let movie = movie else { return nil }
        let image = UIImage(imageLiteralResourceName: movie.imageName ?? "")
        var trailerURL: URL?
        if let trailerPath = movie.trailerLink {
            trailerURL = URL(string: trailerPath)
        }

        return MovieDetailsUIModel(
            title: movie.title ?? "",
            rating: mapRating(rating: movie.rating),
            overview: movie.overview ?? "",
            genre: movie.genre ?? "",
            releasedDate: movie.releasedDate.map(mapReleaseDate(date:)) ?? "",
            showOnMyWatchList: movie.isOnWatchlist,
            trailerURL: trailerURL,
            image: image
        )
    }

    private func mapRating(rating: Double) -> NSAttributedString {
        let fullRatingAttributedString = NSMutableAttributedString()

        let ratingPart = NSAttributedString(
            string: String(rating),
            attributes: [.font: UIFont.boldSystemFont(ofSize: 20)]
        )

        let outOfPart = NSAttributedString(
            string: "/10",
            attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.gray]
        )

        fullRatingAttributedString.append(ratingPart)
        fullRatingAttributedString.append(outOfPart)

        return fullRatingAttributedString
    }

    private func mapReleaseDate(date: Date) -> String {
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy, d MMMM"

        return releaseDateFormatter.string(from: date)
    }
}
