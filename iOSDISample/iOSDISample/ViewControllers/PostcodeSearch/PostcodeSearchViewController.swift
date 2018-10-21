//
//  PostcodeSearchViewController.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/11.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire

final class PostcodeSearchViewController: UIViewController {

    @IBOutlet weak var postcodeField: UITextField!

    /// 郵便番号データ取得ボタンタップ時のイベント
    @IBAction func didTapPostcodeRequest(_ sender: UIButton) {

        // キーボードを表示していたら、閉じる
        if postcodeField.isFirstResponder {
            postcodeField.resignFirstResponder()
        }

        let postcodeRequestDependency = PostcodeRequest.Dependency(
            baseURL: Constants.PostcodeAPI.baseURL,
            path: Constants.PostcodeAPI.pathPostcode,
            parameters: PostcodeRequest.buildParams(postcode: postcodeField.text ?? "", general: true, office: true)
        )
        
        let postcodeRequest = PostcodeRequest(dependency: postcodeRequestDependency)
        
        postcodeRequest.sendAPIRequest().get{ postcodes in
            
            self.showAlert(title: "success".localized(), msg: "first: \(postcodes.data.first?.allAddress ?? "")")
            
            }.catch{ error in
                
                if let postcodeSearchError = error as? PostcodeSearchError {
                    self.showAlert(title: "failure".localized(), msg: postcodeSearchError.message)
                } else {
                    let postcodeSearchError = PostcodeSearchError.others
                    self.showAlert(title: "failure".localized(), msg: postcodeSearchError.message)
                }

            }.finally {
                print("APIRequest処理完了")
        }
    }

    /// アラートを表示する
    ///
    /// - Parameters:
    ///   - title: アラートのタイトル
    ///   - msg: アラートのメッセージ
    private func showAlert(title: String, msg: String) {

        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
    }
}

extension PostcodeSearchViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let postCodeMaxLength = 8

        // 入力文字が空文字の場合はtrue
        if string == "" {
            return true
        }

        let textAfterInput = textField.text ?? "" + string

        if textAfterInput.count < postCodeMaxLength {
            return true
        }

        textField.text = String(textAfterInput.prefix(8))
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
