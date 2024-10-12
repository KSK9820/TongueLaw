//
//  NetworkManager.swift
//  TongueLaw
//
//  Created by 심소영 on 10/8/24.
//

import UIKit
import Moya
import RxSwift
import RxMoya

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init(){}
    let disposeBag = DisposeBag()
    
    private let provider = MoyaProvider<TMDBRouter>()
    
    func requestTMDB<T: Decodable>(endpoint: TMDBRouter, type: T.Type, view: UIViewController? = nil ) -> Single<Result<T, APIError>> {
        return Single.create { observer -> Disposable in
            self.provider.rx.request(endpoint)
                .subscribe { result in
                    switch result {
                    case .success(let response):
                        do {
                            let filteredResponse = try response.filterSuccessfulStatusCodes()
                            let decodedResponse = try JSONDecoder().decode(T.self, from: filteredResponse.data)
                            observer(.success(.success(decodedResponse)))
                        } catch {
                            let apiError = APIError(statusCode: response.statusCode)
                            observer(.success(.failure(apiError)))
                        }
                    case .failure:
                        observer(.success(.failure(.unknownResponse)))
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
}
