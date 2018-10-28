//
//  UIScrollView+Touch.swift
//  iOSDISample
//
//  Created by YukiOkudera on 2018/10/28.
//  Copyright © 2018 YukiOkudera. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}
