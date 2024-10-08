//
//  Router.swift
//  TongueLaw
//
//  Created by 심소영 on 10/8/24.
//

import Foundation
import Moya

enum TMDB {
    
    case searchMovie(query: String)
    case searchTV(query: String)
    case trendingMovie
    case trendingTV
    case genreMovie
    case genreTV
    case similarMovie(id: String)
    case similarTV(id: String)
    case creditsMovie(id: String)
    case creditsTV(id: String)
    
}

extension TMDB: TargetType {
    
    var baseURL: URL { URL(string: "https://api.themoviedb.org/3/")! }
    
    var path: String {
        
        switch self {
        case .searchMovie:
            "search/movie"
        case .searchTV:
            "search/tv"
        case .trendingMovie:
            "trending/movie/week"
        case .trendingTV:
            "trending/tv/week"
        case .genreMovie:
            "genre/movie/list"
        case .genreTV:
            "genre/tv/list"
        case .similarMovie(let id):
            "movie/\(id)/similar"
        case .similarTV(let id):
            "tv/\(id)/similar"
        case .creditsMovie(let id):
            "movie/\(id)/credits"
        case .creditsTV(let id):
            "tv/\(id)/credits"
        }
        
    }
    
    var method: Moya.Method {
        
        switch self {
        default:
                .get
        }
        
    }
    
    var task: Moya.Task {
        
        switch self {
        case .searchMovie(let query), .searchTV(let query):
            let params: [String: String] = [
                "API_KEY": "key",
                "query": query,
                "language": "ko-KR",
                "page": "1"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default )
        case .trendingMovie, .trendingTV, .genreMovie, .genreTV, .creditsMovie, .creditsTV:
            let params: [String: String] = [
                "API_KEY": "key",
                "language": "ko-KR"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default )
        case .similarMovie, .similarTV:
            let params: [String: String] = [
                "API_KEY": "key",
                "language": "ko-KR",
                "page": "1"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default )
        }
        
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
    
}
