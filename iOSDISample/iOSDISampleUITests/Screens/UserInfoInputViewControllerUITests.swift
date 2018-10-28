//
//  UserInfoInputViewControllerUITests.swift
//  iOSDISampleUITests
//
//  Created by YukiOkudera on 2018/10/21.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import XCTest

final class UserInfoInputViewControllerUITests: XCTestCase {

    struct UIComponentIdentifiers {

        static let returnKey = "Return"
        static let okButton = "OK"
        static let doneButton = "done"
        static let nameField = "name_field"
        static let postcodeField = "postcode_field"
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// 郵便番号未入力の場合のテスト
    func testNotInputPostcode() {

        let app = XCUIApplication()

        // リターンキー
        let returnKey = app.buttons[UIComponentIdentifiers.returnKey]

        let okButton = app.buttons[UIComponentIdentifiers.okButton]

        // 氏名フィールド
        let nameField = app.textFields[UIComponentIdentifiers.nameField]
        nameField.tap()

        // 氏名入力
        app.typeText("テスト太郎")

        returnKey.tap()

        // フリガナ入力
        app.typeText("テストタロウ")

        returnKey.tap()

        // TEL入力
        app.typeText("0312345678")

        let doneButton = app.buttons[UIComponentIdentifiers.doneButton]

        doneButton.tap()
        
        // 郵便番号未入力でDoneタップ
        doneButton.tap()

        // アラートのOKボタンをタップ
        okButton.tap()
    }
}
