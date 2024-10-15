//
//  SearchViewModel.swift
//  TongueLaw
//
//  Created by 김수경 on 10/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    
    private let disposeBag = DisposeBag()
    private var searchResult = [SearchDTO]()
    private(set) var trendingResult = [TrendingMovieDTO]()
    
    
    struct Input {
        let searchText: Observable<String>
        let emptySearchResult: Observable<Void>
    }
    
    struct Output {
        let search: Driver<([SearchResponse], Bool)>
        let trending: Driver<[TrendingMovieResponse]>
    }
    
    func transform(_ input: Input) -> Output {
        var searchResult = input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .flatMapLatest { query -> Single<Result<SearchDTO, APIError>> in
                if self.searchResult.count > 0 && self.searchResult[0].page < self.searchResult[0].totalPages {
                    return NetworkManager.shared.requestTMDB(endpoint: .searchMovie(searchQuery: query, page: self.searchResult[0].page + 1), type: SearchDTO.self)
                }
                return NetworkManager.shared.requestTMDB(endpoint: .searchMovie(searchQuery: query), type: SearchDTO.self)
            }
            .map { [weak self] result -> ([SearchResponse], Bool) in
                switch result {
                case .success(let value):
                    self?.searchResult = [value]
                    self?.trendingResult = []
                    
                    return (value.searchResponse, value.page == 1 ? true : false)
                case .failure:
                    return ([], true)
                }
            }
            .asDriver(onErrorJustReturn: ([], true))
            
        
        var trendingResult = input.emptySearchResult
            .flatMapLatest { _ -> Single<Result<TrendingMovieDTO, APIError>> in
                return NetworkManager.shared.requestTMDB(endpoint: .trendingMovie, type: TrendingMovieDTO.self)
            }
            .map { [weak self] result -> [TrendingMovieResponse] in
                switch result {
                case .success(let value):
                    self?.trendingResult = [value]
                    self?.searchResult = []
                    return value.trendingResponse
                case .failure:
                    return []
                }
            }
            .asDriver(onErrorJustReturn: [])
        
     
        
        return Output(search: searchResult, trending: trendingResult)
    }
}
