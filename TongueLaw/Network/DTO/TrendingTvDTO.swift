//
//  TrendingTvDTO.swift
//  TongueLaw
//
//  Created by 심소영 on 10/10/24.
//

import Foundation

// MARK: - TrendingTvDTO
struct TrendingTvDTO: Codable {
    let page: Int
    let trendingTvResponse: [TrendingTvResponse]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - TrendingTvResponse
struct TrendingTvResponse: Codable {
    let backdropPath: String
    let id: Int
    let name, originalName, overview, posterPath: String
    let genreIDs: [Int]
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, name
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case genreIDs = "genre_ids"
        case voteAverage = "vote_average"
    }
}
