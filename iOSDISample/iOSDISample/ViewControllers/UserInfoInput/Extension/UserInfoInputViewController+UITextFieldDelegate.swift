//
//  UserInfoInputViewController+UITextFieldDelegate.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/26.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import UIKit

extension UserInfoInputViewController: UITextFieldDelegate {

    /// テキストフィールドタイプ
    private enum TextFieldType {

        case name
        case phonetic
        case tel
        case postcode

        func maxLength() -> Int {

            switch self {

            case .name, .phonetic:
                return 64
            case .tel:
                return 11
            case .postcode:
                return 8
            }
        }
    }

    /// テキストフィールドタイプを取得する
    private func typeOf(textField: UITextField) -> TextFieldType {

        if textField.isEqual(nameField) {
            return .name
        }

        if textField.isEqual(phoneticField) {
            return .phonetic
        }

        if textField.isEqual(telField) {
            return .tel
        }

        if textField.isEqual(postcodeField) {
            return .postcode
        }

        fatalError("TextFieldTypeに当てはまらない")
    }

    private func nextField(editingField: UITextField) -> UITextField? {

        let editingType = typeOf(textField: editingField)

        switch editingType {

        case .name:
            return phoneticField
        case .phonetic:
            return telField
        case .tel:
            return postcodeField
        case .postcode:
            return nil
        }
    }

    /// テキストフィールドの入力文字の長さチェック
    private func checkLength(textField: UITextField, string: String) -> Bool {

        // 入力文字が空文字の場合はtrue
        if string.isEmpty {
            return true
        }

        // 入力文字とtextField.textを結合
        let textAfterInput = textField.text ?? "" + string

        let textFieldType = typeOf(textField: textField)
        let maxLength = textFieldType.maxLength()

        // 文字数の上限チェック
        if textAfterInput.count <= maxLength {
            return true
        }

        // 上限超過時は、先頭から上限分の長さの文字列をセットする
        textField.text = String(textAfterInput.prefix(maxLength))
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return checkLength(textField: textField, string: string)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        if let nextField = nextField(editingField: textField) {
            nextField.becomeFirstResponder()
        }

        return true
    }
}

extension UserInfoInputViewController {

    /// TELフィールド, 郵便番号フィールドのツールバーのDoneボタンタップイベント
    @objc func didTapDone() {

        if telField.isFirstResponder {
            telField.resignFirstResponder()
            postcodeField.becomeFirstResponder()
            return
        }

        if postcodeField.isFirstResponder {
            postcodeField.resignFirstResponder()

            // 郵便番号で住所を検索ボタンタップ時の処理を実行
            didTapPostcodeRequest(postcodeButton)
            return
        }
    }
}
