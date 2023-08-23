//
//  UITextField+Extension.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/03.
//

import UIKit

extension UITextField {
    func leadPadding(_ leading: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: .zero, y: .zero, width: leading, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
