//
//  UserInfoInputViewController+UITextViewDelegate.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/28.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import UIKit

extension UserInfoInputViewController: UITextViewDelegate {

    /// テキストビュータイプ
    private enum TextViewType {

        case address

        func maxLength() -> Int {

            switch self {

            case .address:
                return 100
            }
        }
    }

    /// テキストビュータイプを取得する
    private func typeOf(textView: UITextView) -> TextViewType {

        if textView.isEqual(addressTextView) {
            return .address
        }

        fatalError("TextViewTypeに当てはまらない")
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // 入力文字が空文字の場合はtrue
        if text.isEmpty {
            return true
        }

        // 変換中の場合はtrue
        if textView.markedTextRange != nil {
            return true
        }
        
        // 入力文字とtextField.textを結合
        let textAfterInput = textView.text ?? "" + text

        let textViewType = typeOf(textView: textView)
        let maxLength = textViewType.maxLength()

        // 文字数の上限チェック
        if textAfterInput.count <= maxLength {
            return true
        }

        // 上限超過時は、先頭から上限分の長さの文字列をセットする
        textView.text = String(textView.text.prefix(maxLength))
        return false
    }

    func textViewDidEndEditing(_ textView: UITextView) {

        let textViewType = typeOf(textView: textView)
        let maxLength = textViewType.maxLength()

        // 文字数の上限チェック
        if textView.text.count <= maxLength {
            return
        }

        // 上限超過時は、先頭から上限分の長さの文字列をセットする
        textView.text = String(textView.text.prefix(maxLength))
    }
}
