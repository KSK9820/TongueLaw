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
        let refresh: ControlEvent<Void>
    }
    
    struct Output {
        let signal: PublishSubject<Void>
        let error: PublishSubject<APIError>
    }
    
    init() {}
    
    func transform(_ input: Input) -> Output {
        let completionSignal = PublishSubject<Void>()
        let error = PublishSubject<APIError>()
        
        input.refresh
            .subscribe(onNext: {
                input.fetchData.onNext(())
            })
            .disposed(by: disposeBag)
        
        let fetchMovies = input.fetchData
            .flatMapLatest { [weak self] _ -> Single<Result<TrendingMovieDTO, APIError>> in
                guard let self = self else {
                    return .just(.failure(APIError.unknownResponse))
                }
                return self.networkManager.requestTMDB(endpoint: .trendingMovie, type: TrendingMovieDTO.self)
            }
            .asObservable()
            .do(onNext: { [weak self] result in
                switch result {
                case .success(let trendingMovies):
                    self?.movies = trendingMovies.trendingResponse
                    if let randomMovie = trendingMovies.trendingResponse.randomElement() {
                        self?.randomMovie = [randomMovie]
                    }
                case .failure(let apiError):
                    error.onNext(apiError)
                }
            })
            .map { _ in () }
        
        let fetchSeries = input.fetchData
            .flatMapLatest { [weak self] _ -> Single<Result<TrendingTvDTO, APIError>> in
                guard let self = self else {
                    return .just(.failure(APIError.unknownResponse))
                }
                return self.networkManager.requestTMDB(endpoint: .trendingTV, type: TrendingTvDTO.self)
            }
            .asObservable()
            .do(onNext: { [weak self] result in
                switch result {
                case .success(let trendingSeries):
                    self?.tvSeries = trendingSeries.trendingTvResponse
                case .failure(let apiError):
                    error.onNext(apiError)
                }
            })
            .map { _ in () }
        
        Observable.zip(fetchMovies, fetchSeries)
            .subscribe(onNext: { _ in
                completionSignal.onNext(())
            })
            .disposed(by: disposeBag)
        
        return Output(signal: completionSignal, error: error)
    }
    
    func addFavoriteList(_ value: FavoriteContent) {
        let _ = coredataManager.createFavoriteObject(value)
    }
}
