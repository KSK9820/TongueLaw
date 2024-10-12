//
//  HomeViewModel.swift
//  TongueLaw
//
//  Created by 최승범 on 10/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

final class HomeViewModel {
    
    private let coredataManager = FavoriteManager()
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    private(set) var movies = [TrendingMovieResponse]()
    private(set) var tvSeries = [TrendingTvResponse]()
    private(set) var randomMovie = [TrendingMovieResponse]()
    
    struct Input {
        let fetchData: BehaviorSubject<Void>
    }
    
    struct Output {
        let trendMovies: BehaviorSubject<[TrendingMovieResponse]>
        let trendSeries: BehaviorSubject<[TrendingTvResponse]>
        let error: PublishSubject<APIError>
    }
    
    init() {}
    
    func transform(_ input: Input) -> Output {
        let trendMovies = BehaviorSubject<[TrendingMovieResponse]>(value: [])
        let trendSeries = BehaviorSubject<[TrendingTvResponse]>(value: [])
        let error = PublishSubject<APIError>()
        
        input.fetchData
            .flatMapLatest { [weak self] _ -> Single<Result<TrendingMovieDTO, APIError>> in
                guard let self = self else {
                    return .just(.failure(APIError.unknownResponse))
                }
                return self.networkManager.requestTMDB(endpoint: .trendingMovie, type: TrendingMovieDTO.self)
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let trendingMovies):
                    self?.movies = trendingMovies.trendingResponse
                    
                    if let randomMovie = trendingMovies.trendingResponse.randomElement() {
                        self?.randomMovie = [randomMovie]
                    }
                    
                    trendMovies.onNext(trendingMovies.trendingResponse)
                    
                case .failure(let apiError):
                    print(apiError)
                    error.onNext(apiError)
                }
            })
            .disposed(by: disposeBag)
        
        input.fetchData
            .flatMapLatest { [weak self] _ -> Single<Result<TrendingTvDTO, APIError>> in
                guard let self = self else {
                    return .just(.failure(APIError.unknownResponse))
                }
                return self.networkManager.requestTMDB(endpoint: .trendingTV, type: TrendingTvDTO.self)
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let trendingSeries):
                    self?.tvSeries = trendingSeries.trendingTvResponse
                    trendSeries.onNext(trendingSeries.trendingTvResponse)
                    
                case .failure(let apiError):
                    error.onNext(apiError)
                }
            })
            .disposed(by: disposeBag)
        
        
        return Output(trendMovies: trendMovies, trendSeries: trendSeries, error: error)
    }
    
    func addFavoriteList(_ value: FavoriteContent) {
        let _ = coredataManager.createFavoriteObject(value)
    }
}
