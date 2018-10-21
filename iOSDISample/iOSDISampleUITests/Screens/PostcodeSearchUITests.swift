//
//  PostcodeSearchUITests.swift
//  iOSDISampleUITests
//
//  Created by YukiOkudera on 2018/10/21.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import XCTest

class PostcodeSearchUITests: XCTestCase {

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

    /// 存在しない郵便番号を入力した場合のテスト
    func testNotExistPostcode() {

        let app = XCUIApplication()
        app.textFields[UIComponentIdentifiers.PostcodeSearch.postcodeField].tap()

        app.keys["1"].tap()
        app.keys["2"].tap()
        app.keys["3"].tap()
        app.keys["4"].tap()
        app.keys["5"].tap()
        app.keys["6"].tap()
        app.keys["7"].tap()
        app.keys["8"].tap()
        app.keys["8"].tap()
        app.keys["8"].tap()

        let deleteKey = app.keys["Delete"]
        deleteKey.tap()
        deleteKey.tap()
        
        app.keys["9"].tap()

        app.buttons[UIComponentIdentifiers.PostcodeSearch.requestButton].tap()
        app.alerts["失敗"].buttons["OK"].tap()


    }
}
