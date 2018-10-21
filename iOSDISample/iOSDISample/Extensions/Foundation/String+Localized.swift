//
//  String+Localized.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/21.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import Foundation

extension String {

    /// selfをキーとしてLocalizable.stringsで定義した文字列を取得する
    func localized() -> String {
        return NSLocalizedString(self, bundle: Bundle.main, comment: "")
    }
}
