//
//  TrendingMovieDTO.swift
//  TongueLaw
//
//  Created by 심소영 on 10/10/24.
//

import Foundation

// MARK: - TrendingMovieDTO
struct TrendingMovieDTO: Codable {
    let page: Int
    let trendingResponse: [TrendingMovieResponse]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, resultss
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - TrendingMovieResponse
struct TrendingMovieResponse: Codable {
    let backdropPath: String
    let id: Int
    let title, originalTitle, overview, posterPath: String
    let genreIDs: [Int]
    let releaseDate: String
    let voteAverage: Double
    let video: Bool

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, title, video
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case genreIDs = "genre_ids"
        case voteAverage = "vote_average"
    }
}
