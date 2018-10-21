//
//  Injectable.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/11.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import Foundation

protocol Injectable {
    associatedtype Dependency
    init(dependency: Dependency)
}
