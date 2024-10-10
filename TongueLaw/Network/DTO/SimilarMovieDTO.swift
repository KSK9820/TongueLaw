//
//  SimilarMovieDTO.swift
//  TongueLaw
//
//  Created by 심소영 on 10/10/24.
//

import Foundation

// MARK: - SimilarMovieDTO
struct SimilarMovieDTO: Codable {
    let page: Int
    let similarMovieResponse: [SimilarMovieResponse]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - SimilarMovieResponse
struct SimilarMovieResponse: Codable {
    let backdropPath: String?
    let genreIDs: [Int]
    let id: Int
    let originalTitle, overview: String
    let posterPath: String?
    let title: String
    let video: Bool
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case title, video
        case voteAverage = "vote_average"
    }
}
