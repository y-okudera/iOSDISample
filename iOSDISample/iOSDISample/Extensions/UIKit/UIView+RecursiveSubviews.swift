//
//  UIView+RecursiveSubviews.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/28.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import UIKit

extension UIView {

    /// サブビューを再帰的に取得する
    ///
    /// subviewsのsubviewsを再帰的に取得
    var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }

    /// 再帰的なサブビュー内からUIViewの特定のサブクラスのビューを取得
    func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
        return recursiveSubviews.compactMap { $0 as? T }
    }
}
