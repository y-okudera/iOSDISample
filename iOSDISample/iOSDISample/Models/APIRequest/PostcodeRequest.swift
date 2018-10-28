//
//  PostcodeRequest.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/21.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import Alamofire
import PromiseKit

/// 郵便番号APIエラー
enum PostcodeSearchError: Error {
    
    case empty
    case searchFailed
    case unreachable
    case serverError
    case others
    
    var message: String {
        switch self {
        case .empty:
            return "postcode_search_error_empty".localized()
        case .searchFailed:
            return "postcode_search_error_searchFailed".localized()
        case .unreachable:
            return "postcode_search_error_unreachable".localized()
        case .serverError:
            return "postcode_search_error_serverError".localized()
        case .others:
            return "postcode_search_error_others".localized()
        }
    }

    init(apiError: APIError) {

        switch apiError {

        case APIError.connectionError(let error, let statusCode):

            if error.isOffline {
                print("isOffline")
                self = .unreachable
                return
            }

            if error.isTimeout {
                print("isTimeout")
                self = .unreachable
                return
            }

            // HTTPステータスコードが500台の場合はサーバエラーを返す
            if 500 ..< 600 ~= statusCode {
                print("serverError")
                self = .serverError
                return
            }

            self = .searchFailed

        case APIError.invalidResponse:
            print("invalidResponse")
            self = .searchFailed

        case APIError.parseError:
            print("parseError")
            self = .searchFailed
        }
    }
}

/// 郵便番号APIリクエスト
struct PostcodeRequest: APIRequest, InitializerInjectable {
    
    struct Dependency {
        let baseURL: String
        let path: String
        let parameters: [String : Any]
    }
    
    /// baseURL, path, parametersをイニシャライザで注入する
    init(dependency: PostcodeRequest.Dependency) {
        self.dependency = dependency
    }
    
    private let dependency: PostcodeRequest.Dependency
    
    typealias ResponseComponent = Postcode
    typealias Response = Postcodes
    typealias ErrorType = PostcodeSearchError
    
    var baseURL: String {
        return dependency.baseURL
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return dependency.path
    }
    
    var parameters: [String : Any] {
        return dependency.parameters
    }
    
    /// リクエストパラメータを生成する
    static func buildParams(postcode: String, general: Bool, office: Bool) -> [String: Any] {
        return [
            "general": general ? "true" : "false",
            "office": office ? "true" : "false",
            "postcode": postcode
        ]
    }
    
    func sendAPIRequest() -> Promise<Response> {

        return Promise<Response> { resolver in
            
            APIClient.request(request: self)
                .get { postcodes in
                    
                    // 空チェック
                    if postcodes.data.isEmpty {
                        resolver.reject(PostcodeSearchError.empty)
                        return
                    }
                    
                    // リクエスト成功
                    resolver.fulfill(postcodes)
                }
                .catch { error in

                    if let apiError = error as? APIError {
                        resolver.reject(PostcodeSearchError(apiError: apiError))
                    } else {
                        print("error object is not contain to APIError type.")
                        resolver.reject(PostcodeSearchError.others)
                    }
            }
        }
    }
}
