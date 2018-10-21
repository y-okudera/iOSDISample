//
//  APIRequest.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/21.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import Alamofire
import PromiseKit

/// APIリクエストプロトコル
protocol APIRequest {
    
    associatedtype Response
    associatedtype ErrorType
    
    /// ベースURL
    var baseURL: String { get }
    
    /// HTTPヘッダフィールド
    var httpHeaderFields: [String: String] { get }
    
    /// HTTPメソッド
    ///
    /// e.g. get, head, post ...
    var method: HTTPMethod { get }
    
    /// APIのPATH
    var path: String { get }
    
    /// APIのリクエストパラメータ
    var parameters: [String: Any] { get }
    
    /// APIリクエストを実行する
    func sendAPIRequest() -> Promise<Response>
    
    /// APIから返却されたデータからResponseオブジェクトを生成する
    ///
    /// - Parameter data: APIから取得したデータ
    /// - Returns: Responseオブジェクト
    func responseFromData(data: Data) -> Response?
}

// MARK: - httpHeaderFieldsのデフォルト実装
extension APIRequest {
    
    var httpHeaderFields: [String: String] {
        return [:]
    }
}

// MARK: - レスポンスデータのデコード処理のデフォルト実装
extension APIRequest where Response: Codable {
    
    func responseFromData(data: Data) -> Response? {
        
        print("responseData: \(String(data: data, encoding: .utf8) ?? "")")
        
        let model = try? JSONDecoder().decode(Response.self, from: data)
        return model
    }
}
