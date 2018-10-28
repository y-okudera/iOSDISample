//
//  UIViewController+ShowAlert.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/28.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// アラートを表示する(OKボタンのみ、ボタンタップ時処理なし)
    ///
    /// - Parameters:
    ///   - title: アラートのタイトル
    ///   - msg: アラートのメッセージ
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
