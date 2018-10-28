//
//  UITextField+DoneToolbar.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/27.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import UIKit

extension UITextField {

    /// Doneツールバーを追加する
    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil) {

        let onDone = onDone ?? (target: self, action: #selector(didTapDone))

        let toolbar = UIToolbar()
        toolbar.barStyle = .default

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: onDone.target, action: onDone.action)
        doneButton.accessibilityIdentifier = "done"
        
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            doneButton
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }
    
    @objc func didTapDone() {
        self.resignFirstResponder()
    }
}
