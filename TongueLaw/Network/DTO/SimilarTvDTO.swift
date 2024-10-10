//
//  SimilarTvDTO.swift
//  TongueLaw
//
//  Created by 심소영 on 10/10/24.
//

import Foundation


// MARK: - SimilarTvDTO
struct SimilarTvDTO: Codable {
    let page: Int
    let similarTvResponse: [SimilarTvResponse]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - SimilarTvResponse
struct SimilarTvResponse: Codable {
    let backdropPath: String?
    let genreIDs: [Int]
    let id: Int
    let originalLanguage, originalName, overview: String
    let posterPath: String?
    let name: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case name
        case voteAverage = "vote_average"
    }
}


