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
    case other(Error)
    case badRequest
    case unauthorized

    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .bodyEmpty
        case 401:
            self = .badRequest
        default:
            self = .unknownResponse
        }
    }

    var errorMessage: String {
        switch self {
        case .unknownResponse:
            return "알 수 없는 오류가 발생했습니다."
        case .bodyEmpty:
            return "요청 본문이 비어 있습니다."
        case .badRequest:
            return "잘못된 요청입니다."
        case .unauthorized:
            return "인증이 필요합니다."
        case .other(let error):
            return error.localizedDescription
        }
    }
}


final class NetworkManager {
    
    static let shared = NetworkManager()
    private init(){}
    let disposeBag = DisposeBag()
    
    private let provider = MoyaProvider<TMDBRouter>()
    
    func requestTMDB<T: Decodable>(
        endpoint: TMDBRouter,
        type: T.Type,
        view: UIViewController? = nil
    ) -> Single<Result<T, APIError>> {
        
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
                    case .failure(let error):
                        observer(.success(.failure(.other(error))))
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func errorHandler(statusCode: Int?, view: UIViewController?) {
        if let code = statusCode {
            switch code {
            case 400:
                print("잘못된 요청 - Bad Request")
            case 401:
                print("인증 오류 - Unauthorized")
            default:
                print("기타 오류 발생 - \(code)")
            }
        } else {
            print("알 수 없는 오류 발생")
        }
    }
    
    
}
