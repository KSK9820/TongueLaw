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

enum APIError: Error {
    case unknownResponse
    case bodyEmpty
    case notUserWrongPassword
    case other(Error)
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init(){}
    let disposeBag = DisposeBag()
    
    private let provider = MoyaProvider<TMDBRouter>()
    
    func searchMovie(searchQuery: String, completion: @escaping (SearchResponse?, Int?) -> Void) {
        provider.rx.request(.searchMovie(searchQuery: searchQuery))
            .map(SearchResponse.self)
            .subscribe { event in
                switch event {
                case .success(let response):
                    completion(response, 200)
                case .failure(let error):
                    completion(nil, error.asAFError?.responseCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func requestTMDB<T: Decodable>(
            endpoint: Router, // Moya의 TargetType에 해당하는 Router
            type: T.Type, // 디코딩할 모델 타입
            view: UIViewController? = nil // 오류 핸들링을 위한 UIViewController (옵셔널)
        ) -> Single<Result<T, APIError>> {
            
            return Single.create { observer -> Disposable in
                // Moya의 provider를 통해 요청을 보냄
                self.provider.rx.request(endpoint)
                    .subscribe { result in
                        switch result {
                        case .success(let response):
                            do {
                                let filteredResponse = try response.filterSuccessfulStatusCodes() // 상태 코드가 200~299일 경우만 통과
                                let decodedResponse = try JSONDecoder().decode(T.self, from: filteredResponse.data)
                                print("요청 성공: \(type)")
                                observer(.success(.success(decodedResponse)))
                            } catch {
                                print("디코딩 실패 또는 상태 코드 오류: \(error)")
                                self.errorHandler(statusCode: response.statusCode, view: view)
                                observer(.success(.failure(.unknownResponse)))
                            }
                        case .failure(let error):
                            print("네트워크 실패: \(error)")
                            self.errorHandler(statusCode: nil, view: view)
                            observer(.success(.failure(.other(error))))
                        }
                    }
                    .disposed(by: self.disposeBag)
                
                return Disposables.create()
            }
        }
        

    
}
