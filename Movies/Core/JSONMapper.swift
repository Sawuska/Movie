//
//  JSONMovieMapper.swift
//  Movies
//
//  Created by Alexandra on 25.12.2023.
//

import Foundation

class JSONMapper<T: Decodable> {

    func mapData(_ data: Data) -> T? {
        var mapped: T?
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd"
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            mapped = try jsonDecoder.decode(T.self, from: data)
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        return mapped
    }
}
