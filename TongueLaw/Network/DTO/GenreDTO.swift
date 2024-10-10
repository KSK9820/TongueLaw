//
//  GenreDTO.swift
//  TongueLaw
//
//  Created by 심소영 on 10/10/24.
//

import Foundation

// MARK: - GenreDTO
struct GenreDTO: Decodable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Decodable {
    let id: Int
    let name: String
}
