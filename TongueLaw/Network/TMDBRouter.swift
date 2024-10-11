//
//  TMDBRouter.swift
//  TongueLaw
//
//  Created by 심소영 on 10/8/24.
//

import Foundation
import Moya

enum TMDBRouter {
    
    case searchMovie(searchQuery: String)
    case searchTV(searchQuery: String)
    case trendingMovie
    case trendingTV
    case genreMovie
    case genreTV
    case similarMovie(movieId: String)
    case similarTV(seriesId: String)
    case creditsMovie(movieId: String)
    case creditsTV(seriesId: String)
    case image(imagePath: String)
    
    static var apiKey = Bundle.main.infoDictionary?["APIKEY"] as? String ?? "key 없음"
}

extension TMDBRouter: TargetType {
    
    var baseURL: URL {
        
        switch self {
        case .image(let path):
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else {
                fatalError("잘못된 URL입니다.")
            }
            return url
        
        default:
            guard let url = URL(string: "https://api.themoviedb.org/3/") else {
                fatalError("잘못된 URL입니다.")
            }
            return url
            
        }
    }
    
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
        case .similarMovie(let movieId):
            "movie/\(movieId)/similar"
        case .similarTV(let seriesId):
            "tv/\(seriesId)/similar"
        case .creditsMovie(let movieId):
            "movie/\(movieId)/credits"
        case .creditsTV(let seriesId):
            "tv/\(seriesId)/credits"
        default:
            ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            .get
        }
    }
    
    var task: Moya.Task {
        
        var baseParams: [String: String] = [
            "api_key": TMDBRouter.apiKey,
            "language": "ko-KR"
        ]
        
        switch self {
        case .searchMovie(let searchQuery), .searchTV(let searchQuery):
            baseParams["query"] = searchQuery
            return .requestParameters(parameters: baseParams, encoding: URLEncoding.default)
            
        case .trendingMovie, .trendingTV, .genreMovie, .genreTV, .creditsMovie, .creditsTV:
            return .requestParameters(parameters: baseParams, encoding: URLEncoding.default)
            
        case .similarMovie, .similarTV:
            baseParams["page"] = "1"
            return .requestParameters(parameters: baseParams, encoding: URLEncoding.default)
            
        default:
            return .requestParameters(parameters: baseParams, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}


