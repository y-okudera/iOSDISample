//
//  PostcodeRequestTests.swift
//  iOSDISampleTests
//
//  Created by YukiOkudera on 2018/10/21.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

@testable import iOSDISample
import XCTest

final class PostcodeRequestTests: XCTestCase {

    /// 郵便番号検索APIリクエストが成功する場合のテスト
    ///
    /// リクエストパラメータ: postcode=3320000, general=true, office=true
    ///
    /// 期待結果1: postcodes.data.count == 1
    ///
    /// 期待結果2: postcodes.data.first?.allAddress == 埼玉県川口市
    ///
    /// 期待結果3: レスポンス取得時間1.0秒未満
    func testRequestSuccess() {

        let expectation: XCTestExpectation = self.expectation(description: "郵便番号検索APIリクエストが成功する場合のテスト")

        let params = PostcodeRequest.buildParams(postcode: "3320000", general: true, office: true)
        let postcodeRequestDependency = PostcodeRequest.Dependency(baseURL: "https://postcode-jp.appspot.com",
                                                                   path: "/api/postcode",
                                                                   parameters: params)

        let postcodeRequest = PostcodeRequest(dependency: postcodeRequestDependency)

        postcodeRequest.sendAPIRequest().get{ postcodes in

            XCTAssertEqual(postcodes.data.count, 1)
            XCTAssertEqual(postcodes.data.first?.allAddress, "埼玉県川口市")
            expectation.fulfill()

            }.catch { error in

                if let postcodeSearchError = error as? PostcodeSearchError {
                    XCTFail("リクエスト失敗: \(postcodeSearchError)")
                } else {
                    XCTFail("PostcodeSearchErrorへのキャスト失敗")
                }

        }
        self.wait(for: [expectation], timeout: 1.0)
    }

    /// HTTPステータスコード200(OK)でJSONのデコードが失敗する場合のテスト
    ///
    /// リクエストパラメータ: postcode=3320000, general=true, office=true
    ///
    /// 期待結果1: catch句のerrorオブジェクト == PostcodeSearchError.searchFailed
    ///
    /// 期待結果2: errorオブジェクトのmessage == "住所の検索に失敗しました。"
    ///
    /// 期待結果3: レスポンス取得時間1.0秒未満
    func testStatusCode200ButDecodingFailure() {

        let expectation: XCTestExpectation = self.expectation(description: "HTTPステータスコード200でJSONのデコードが失敗する場合のテスト")

        let params = PostcodeRequest.buildParams(postcode: "3320000", general: true, office: true)
        let postcodeRequestDependency = PostcodeRequest.Dependency(baseURL: "http://httpbin.org/status",
                                                                   path: "/200",
                                                                   parameters: params)

        let postcodeRequest = PostcodeRequest(dependency: postcodeRequestDependency)

        postcodeRequest.sendAPIRequest().get{ postcodes in

            XCTFail("Errorが発生していない")

            }.catch { error in

                if let postcodeSearchError = error as? PostcodeSearchError {

                    XCTAssertEqual(postcodeSearchError, PostcodeSearchError.searchFailed)
                    XCTAssertEqual(postcodeSearchError.message, "住所の検索に失敗しました。")
                    expectation.fulfill()
                } else {
                    XCTFail("PostcodeSearchErrorへのキャスト失敗")
                }

        }
        self.wait(for: [expectation], timeout: 1.0)
    }

    /// HTTPステータスコード305(Use Proxy)の場合のテスト
    ///
    /// リクエストパラメータ: postcode=3320000, general=true, office=true
    ///
    /// 期待結果1: catch句のerrorオブジェクト == PostcodeSearchError.searchFailed
    ///
    /// 期待結果2: errorオブジェクトのmessage == "住所の検索に失敗しました。"
    ///
    /// 期待結果3: レスポンス取得時間1.0秒未満
    func testStatusCode305() {

        let expectation: XCTestExpectation = self.expectation(description: "HTTPステータスコード305の場合のテスト")

        let params = PostcodeRequest.buildParams(postcode: "3320000", general: true, office: true)
        let postcodeRequestDependency = PostcodeRequest.Dependency(baseURL: "http://httpbin.org/status",
                                                                   path: "/305",
                                                                   parameters: params)

        let postcodeRequest = PostcodeRequest(dependency: postcodeRequestDependency)

        postcodeRequest.sendAPIRequest().get{ postcodes in

            XCTFail("Errorが発生していない")

            }.catch { error in

                if let postcodeSearchError = error as? PostcodeSearchError {

                    XCTAssertEqual(postcodeSearchError, PostcodeSearchError.searchFailed)
                    XCTAssertEqual(postcodeSearchError.message, "住所の検索に失敗しました。")
                    expectation.fulfill()
                } else {
                    XCTFail("PostcodeSearchErrorへのキャスト失敗")
                }

        }
        self.wait(for: [expectation], timeout: 1.0)
    }

    /// HTTPステータスコード404(Not Found)の場合のテスト
    ///
    /// リクエストパラメータ: postcode=3320000, general=true, office=true
    ///
    /// 期待結果1: catch句のerrorオブジェクト == PostcodeSearchError.searchFailed
    ///
    /// 期待結果2: errorオブジェクトのmessage == "住所の検索に失敗しました。"
    ///
    /// 期待結果3: レスポンス取得時間1.0秒未満
    func testStatusCode404() {

        let expectation: XCTestExpectation = self.expectation(description: "HTTPステータスコード404の場合のテスト")

        let params = PostcodeRequest.buildParams(postcode: "3320000", general: true, office: true)
        let postcodeRequestDependency = PostcodeRequest.Dependency(baseURL: "http://httpbin.org/status",
                                                                   path: "/404",
                                                                   parameters: params)

        let postcodeRequest = PostcodeRequest(dependency: postcodeRequestDependency)

        postcodeRequest.sendAPIRequest().get{ postcodes in

            XCTFail("Errorが発生していない")

            }.catch { error in

                if let postcodeSearchError = error as? PostcodeSearchError {

                    XCTAssertEqual(postcodeSearchError, PostcodeSearchError.searchFailed)
                    XCTAssertEqual(postcodeSearchError.message, "住所の検索に失敗しました。")
                    expectation.fulfill()
                } else {
                    XCTFail("PostcodeSearchErrorへのキャスト失敗")
                }

        }
        self.wait(for: [expectation], timeout: 1.0)
    }

    /// HTTPステータスコード503(Service Unavailable)の場合のテスト
    ///
    /// リクエストパラメータ: postcode=3320000, general=true, office=true
    ///
    /// 期待結果1: catch句のerrorオブジェクト == PostcodeSearchError.serverError
    ///
    /// 期待結果2: errorオブジェクトのmessage == "住所の検索に失敗しました。"
    ///
    /// 期待結果3: レスポンス取得時間1.0秒未満
    func testStatusCode503() {

        let expectation: XCTestExpectation = self.expectation(description: "HTTPステータスコード503の場合のテスト")

        let params = PostcodeRequest.buildParams(postcode: "3320000", general: true, office: true)
        let postcodeRequestDependency = PostcodeRequest.Dependency(baseURL: "http://httpbin.org/status",
                                                                   path: "/503",
                                                                   parameters: params)

        let postcodeRequest = PostcodeRequest(dependency: postcodeRequestDependency)

        postcodeRequest.sendAPIRequest().get{ postcodes in

            XCTFail("Errorが発生していない")

            }.catch { error in

                if let postcodeSearchError = error as? PostcodeSearchError {

                    XCTAssertEqual(postcodeSearchError, PostcodeSearchError.serverError)
                    XCTAssertEqual(postcodeSearchError.message, "サーバエラーが発生しました。")
                    expectation.fulfill()
                } else {
                    XCTFail("PostcodeSearchErrorへのキャスト失敗")
                }

        }
        self.wait(for: [expectation], timeout: 1.0)
    }
}
