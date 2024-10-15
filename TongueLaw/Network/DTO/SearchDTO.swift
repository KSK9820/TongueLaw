//
//  SearchDTO.swift
//  TongueLaw
//
//  Created by 심소영 on 10/10/24.
//

import Foundation

// MARK: - SearchDTO
struct SearchDTO: Decodable {
    var page: Int
    var searchResponse: [SearchResponse]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case searchResponse = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - SearchResponse
struct SearchResponse: Decodable {
    let backdropPath: String
    let genreIDs: [Int]
    let id: Int
    let originalTitle, overview: String
    let posterPath, title: String
    let voteAverage: Double
    let video: Bool

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


