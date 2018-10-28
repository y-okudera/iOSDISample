//
//  UserInfoConfirmViewControllerTests.swift
//  iOSDISampleTests
//
//  Created by YukiOkudera on 2018/10/28.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

@testable import iOSDISample
import XCTest

final class UserInfoConfirmViewControllerTests: XCTestCase {

    var userInfoConfirmVC: UserInfoConfirmViewController?

    override func setUp() {
        
        let mock = UserInfoConfirmViewController.Dependency(
            userName: "テスト太郎",
            phonetic: "テストタロウ",
            tel: "0312345678",
            address: "埼玉県川口市xx1-2-3"
        )
        userInfoConfirmVC = UserInfoConfirmViewController.make(dependency: mock)

        if let userInfoConfirmVC = self.userInfoConfirmVC {
            userInfoConfirmVC.performSelector(
                onMainThread: #selector(userInfoConfirmVC.loadView),
                with: nil,
                waitUntilDone: true
            )
        }
    }

    /// 値が正しく代入されていることをテスト
    func testArguments() {
        XCTAssertEqual(userInfoConfirmVC?.userName, "テスト太郎")
        XCTAssertEqual(userInfoConfirmVC?.phonetic, "テストタロウ")
        XCTAssertEqual(userInfoConfirmVC?.tel, "0312345678")
        XCTAssertEqual(userInfoConfirmVC?.address, "埼玉県川口市xx1-2-3")
    }
}
