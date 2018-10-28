//
//  KeyboardEventObservable.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/28.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import UIKit

/// キーボード表示/非表示の通知を受け取った時に実行するSelectorでコールする処理を定義
@objc protocol KeyboardEvent: class {
    
    @objc func keyboardWillShow(_ notification: Notification)
    @objc func keyboardWillHide(_ notification: Notification)
}

/// キーボード監視
protocol KeyboardEventObservable: KeyboardEvent {
    
    var scrollView: UIScrollView! { get }
    
    func addKeyboardEventObservers()
    func removeKeyboardEventObservers()
    
    func keyboardShowAction(_ notification: Notification)
    func keyboardHideAction(_ notification: Notification)
}

extension KeyboardEventObservable where Self: UIViewController {
    
    func addKeyboardEventObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeKeyboardEventObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func keyboardShowAction(_ notification: Notification) {
        
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                return
        }
        
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        UIView.animate(withDuration: duration, animations: {
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardHideAction(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}
