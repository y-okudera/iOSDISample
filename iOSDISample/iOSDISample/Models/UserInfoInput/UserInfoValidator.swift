//
//  UserInfoValidator.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/29.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import UIKit

enum UserInfoValidationError: Error {
    case nameIsEmpty 
    case phoneticIsEmpty
    case telIsEmpty
    case addressIsEmpty

    var message: String {
        switch self {
        case .nameIsEmpty:
            return "name_is_empty".localized()
        case .phoneticIsEmpty:
            return "phonetic_is_empty".localized()
        case .telIsEmpty:
            return "tel_is_empty".localized()
        case .addressIsEmpty:
            return "address_is_empty".localized()
        }
    }
}

final class UserInfoValidator {
    
    static func validate(name: String, phonetic: String, tel: String, address: String) -> UserInfoValidationError? {
        
        if name.isEmpty {
            return .nameIsEmpty
        }
        
        if phonetic.isEmpty {
            return .phoneticIsEmpty
        }
        
        if tel.isEmpty {
            return .telIsEmpty
        }
        
        if address.isEmpty {
            return .addressIsEmpty
        }
        
        return nil
    }
}
