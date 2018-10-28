//
//  UserInfoInputViewController.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/11.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import PromiseKit

final class UserInfoInputViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    /// 氏名フィールド
    @IBOutlet weak var nameField: UITextField!
    /// フリガナフィールド
    @IBOutlet weak var phoneticField: UITextField!
    /// TELフィールド
    @IBOutlet @objc weak var telField: UITextField! {
        didSet {
            telField?.addDoneToolbar(onDone: (target: self, action: #selector(didTapDone)))
        }
    }
    /// 郵便番号フィールド
    @IBOutlet weak var postcodeField: UITextField! {
        didSet {
            postcodeField?.addDoneToolbar(onDone: (target: self, action: #selector(didTapDone)))
        }
    }
    /// 郵便番号で住所を検索ボタン
    @IBOutlet weak var postcodeButton: UIButton!
    /// 住所テキストビュー
    @IBOutlet weak var addressTextView: UITextView!
    /// 次へボタン
    @IBOutlet weak var nextButton: UIButton!

    // MARK: - Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardEventObservers()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardEventObservers()
    }

    // MARK: - UIResponder

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // TextField, TextViewの編集を終了する
        endEditingOfAllFields()
        endEditingOfAllTextViews()
    }

    // MARK: - IBActions

    /// 郵便番号で住所を検索ボタンタップ時のイベント
    @IBAction func didTapPostcodeRequest(_ sender: UIButton) {
        print("郵便番号で住所を検索ボタンタップ")

        let postcode = postcodeField.text ?? ""
        if postcode.isEmpty {
            self.showAlert(title: "failure".localized(), message: "postcode_is_empty".localized())
            return
        }

        // TextField, TextViewの編集を終了する
        endEditingOfAllFields()
        endEditingOfAllTextViews()

        let postcodeRequestDependency = PostcodeRequest.Dependency(
            baseURL: Constants.PostcodeAPI.baseURL,
            path: Constants.PostcodeAPI.pathPostcode,
            parameters: PostcodeRequest.buildParams(postcode: postcode, general: true, office: true)
        )
        let postcodeRequest = PostcodeRequest(dependency: postcodeRequestDependency)

        startAnimating()
        postcodeRequest.sendAPIRequest()
            .get { postcodes in

                let address = postcodes.data.first?.allAddress ?? ""
                self.addressTextView.text = address
            }
            .catch { error in
                
                if let postcodeSearchError = error as? PostcodeSearchError {
                    self.showAlert(title: "failure".localized(), message: postcodeSearchError.message)
                } else {
                    print("error object is not contain to PostcodeSearchError type.")
                    let postcodeSearchError = PostcodeSearchError.others
                    self.showAlert(title: "failure".localized(), message: postcodeSearchError.message)
                }
            }
            .finally {

                self.stopAnimating()
                print("APIRequest処理完了")
        }
    }

    /// 次へボタンタップ時のイベント
    @IBAction func didTapNext(_ sender: UIButton) {
        print("次へボタンタップ")

        // TextField, TextViewの編集を終了する
        endEditingOfAllFields()
        endEditingOfAllTextViews()

        let name = nameField.text ?? ""
        let phonetic = phoneticField.text ?? ""
        let tel = telField.text ?? ""
        let address = addressTextView.text ?? ""
        if let validationError = UserInfoValidator.validate(name: name,
                                                            phonetic: phonetic,
                                                            tel: tel,
                                                            address: address) {
            showAlert(title: "error".localized(), message: validationError.message)
            return
        }

        let userInfoConfirmVCDependency = UserInfoConfirmViewController.Dependency(
            userName: name,
            phonetic: phonetic,
            tel: tel,
            address: address
        )

        let vc = UserInfoConfirmViewController.make(dependency: userInfoConfirmVCDependency)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - KeyboardEventObservable
extension UserInfoInputViewController: KeyboardEventObservable {

    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardShowAction(notification)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardHideAction(notification)
    }
}

// MARK: - NVActivityIndicatorViewable
extension UserInfoInputViewController: NVActivityIndicatorViewable {}
