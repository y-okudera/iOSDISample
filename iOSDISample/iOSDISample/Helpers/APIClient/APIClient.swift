//
//  APIClient.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/21.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import Alamofire
import PromiseKit

/// APIエラータイプ
///
/// - connectionError: HTTP関連エラー -> Errorオブジェクト, HTTPステータスコードを返却
/// - invalidResponse: HTTPURLResponseオブジェクト,Alamofire.Resultオブジェクトがnil
/// - parseError: Codableに準拠したオブジェクトへのマッピング失敗
enum APIError: Error {
    case connectionError(Error, Int)
    case invalidResponse
    case parseError
}

struct APIClient {
    
    /// APIリクエストを実行する
    ///
    /// HTTPステータスコード200番台を成功とする
    ///
    /// - Parameter request: APIRequestプロトコルに準拠したオブジェクト
    /// - Returns: Promise<T.Response>
    static func request<T: APIRequest>(request: T) -> Promise<T.Response> {
        
        let endPoint = request.baseURL + request.path
        let method = request.method
        let parameters = request.parameters
        let headers = request.httpHeaderFields
        
        return Promise<T.Response> { resolver in
            
            Alamofire.request(
                endPoint,
                method: method,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: headers
                )
                .validate(statusCode: 200 ..< 300)
                .responseData { response in
                    
                    // HTTPURLResponseオブジェクトのnilチェック
                    guard let httpURLResponse = response.response else {
                        print("httpURLResponse is nil.")
                        resolver.reject(APIError.invalidResponse)
                        return
                    }

                    print("httpURLResponse.statusCode: \(httpURLResponse.statusCode)")
                    
                    // HTTPリクエスト結果のエラーチェック
                    // 200 ~ 299のステータスコードをレスポンスが持たない場合、errorオブジェクトが得られる
                    if let error = response.result.error {
                        resolver.reject(APIError.connectionError(error, httpURLResponse.statusCode))
                    }
                    
                    // Alamofire.Resultオブジェクトのnilチェック
                    guard let responseData = response.result.value else {
                        print("response.result.value is nil.")
                        resolver.reject(APIError.invalidResponse)
                        return
                    }
                    
                    // Codableに準拠したResponseにデコードする
                    guard let mappedObject = request.responseFromData(data: responseData) else {
                        resolver.reject(APIError.parseError)
                        return
                    }
                    
                    // リクエスト成功
                    resolver.fulfill(mappedObject)
            }
        }
    }
}
