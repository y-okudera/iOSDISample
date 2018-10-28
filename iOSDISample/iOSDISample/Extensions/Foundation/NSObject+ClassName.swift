//
//  NSObject+ClassName.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/28.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import Foundation

extension NSObject {
    
    /// クラス名を取得する
    static var className: String {
        get {
            return String(describing: self)
        }
    }
    
    var className: String {
        get {
            return String(describing: type(of: self))
        }
    }
}
