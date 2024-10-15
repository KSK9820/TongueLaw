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
    private(set) var searchResult = [SearchDTO]()
    private(set) var trendingResult = [TrendingMovieDTO]()
    private var searchKeyword = ""
    
    struct Input {
        let searchText: Observable<String>
        let emptySearchResult: Observable<Void>
    }
    
    struct Output {
        let search: Driver<Void>
        let trending: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        var searchResult = input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .flatMapLatest { [weak self] query -> Single<Result<SearchDTO, APIError>> in
                guard let self else { return Single.error(APIError.unknownResponse) }
                
                if self.searchKeyword != query {
                    self.searchKeyword = query
                    return NetworkManager.shared.requestTMDB(endpoint: .searchMovie(searchQuery: query), type: SearchDTO.self)
                } else if  self.searchResult.count > 0 && self.searchResult[0].page < self.searchResult[0].totalPages {
                    return NetworkManager.shared.requestTMDB(endpoint: .searchMovie(searchQuery: query, page: self.searchResult[0].page + 1), type: SearchDTO.self)
                }
                    
                return Single.error(APIError.unknownResponse)
            }
            .map { [weak self] result in
                switch result {
                case .success(let value):
                    if value.page == 1 {
                        self?.searchResult = [value]
                    } else {
                        self?.searchResult[0].page = value.page
                        self?.searchResult[0].searchResponse += value.searchResponse
                    }
                    return ()
                case .failure(let error):
                    print(error)
                }
            }
            .asDriver(onErrorJustReturn: ())
            
        
        var trendingResult = input.emptySearchResult
            .flatMapLatest { _ -> Single<Result<TrendingMovieDTO, APIError>> in
                return NetworkManager.shared.requestTMDB(endpoint: .trendingMovie, type: TrendingMovieDTO.self)
            }
            .map { [weak self] result in
                switch result {
                case .success(let value):
                    self?.trendingResult = [value]
                    self?.searchResult = []
                    return ()
                case .failure(let error):
                    print(error)
                }
            }
            .asDriver(onErrorJustReturn: ())
        
     
        
        return Output(search: searchResult, trending: trendingResult)
    }
}
