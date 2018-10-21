//
//  Postcodes.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/21.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import Foundation

struct Postcodes: Codable {

    var data = [Postcode]()
    var size = 0
    var limit = 0
    var version = ""
}

struct Postcode: Codable {

    var allCode = ""
    var stateCode = ""
    var townCode = ""
    var zip = ""
    var state = ""
    var town = ""
    var street = ""
    var allAddress = ""
}
