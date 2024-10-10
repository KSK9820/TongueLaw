//
//  File.swift
//  TongueLaw
//
//  Created by 심소영 on 10/10/24.
//

import Foundation

enum APIError: Error {
    case unknownResponse
    case badRequest
    case unauthorized
    
    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .unknownResponse
        default:
            self = .unknownResponse
        }
    }
    
    var errorMessage: String {
        switch self {
        case .unknownResponse:
            return "알 수 없는 오류가 발생했습니다."
        case .badRequest:
            return "잘못된 요청입니다."
        case .unauthorized:
            return "인증이 필요합니다."
        }
    }
}
