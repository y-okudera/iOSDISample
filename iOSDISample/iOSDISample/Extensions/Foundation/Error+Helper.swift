//
//  Error+Helper.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/21.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import Foundation

extension Error {

    private var nsError: NSError {
        return self as NSError
    }

    /// オフライン
    var isOffline: Bool {
        return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet
    }
    
    /// タイムアウト
    var isTimeout: Bool {
        return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorTimedOut
    }
}
