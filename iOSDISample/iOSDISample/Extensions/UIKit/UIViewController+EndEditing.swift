//
//  UIViewController+EndEditing.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/28.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import UIKit

extension UIViewController {

    /// UITextFieldのサブクラスのビューを取得し、resignFirstResponderをコールする
    func endEditingOfAllFields() {

        let textFields = self.view.findViews(subclassOf: UITextField.self)
        for textField in textFields where textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }

    /// UITextViewのサブクラスのビューを取得し、resignFirstResponderをコールする
    func endEditingOfAllTextViews() {

        let textViews = self.view.findViews(subclassOf: UITextView.self)
        for textView in textViews where textView.isFirstResponder {
            textView.resignFirstResponder()
        }
    }
}
