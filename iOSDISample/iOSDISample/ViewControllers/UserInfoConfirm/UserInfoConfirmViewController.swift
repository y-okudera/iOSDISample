//
//  UserInfoConfirmViewController.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/28.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import UIKit

final class UserInfoConfirmViewController: UIViewController, MethodInjectable {

    var userName: String!
    var phonetic: String!
    var tel: String!
    var address: String!
    
    struct Dependency {
        let userName: String
        let phonetic: String
        let tel: String
        let address: String
    }

    func inject(dependency: UserInfoConfirmViewController.Dependency) {
        self.userName = dependency.userName
        self.phonetic = dependency.phonetic
        self.tel = dependency.tel
        self.address = dependency.address
    }

    static func make(dependency: UserInfoConfirmViewController.Dependency) -> UserInfoConfirmViewController {

        let vcName = UserInfoConfirmViewController.className
        let vc = UIStoryboard.viewController(
            storyboardName: vcName,
            identifier: vcName) as! UserInfoConfirmViewController

        vc.inject(dependency: dependency)

        return vc
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        print("userName: \(userName ?? "")")
        print("phonetic: \(phonetic ?? "")")
        print("tel: \(tel ?? "")")
        print("address: \(address ?? "")")
    }
}
