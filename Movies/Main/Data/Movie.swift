//
//  Movie.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import Foundation

struct Movie: Decodable {

    let title: String
    let description: String
    let rating: Double
    let duration: Int
    let genre: String?
    let releasedDate: Date?
    let trailerLink: String?
    let imageName: String?
}
