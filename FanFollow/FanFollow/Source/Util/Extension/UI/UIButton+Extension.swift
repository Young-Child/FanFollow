//
//  UIButton+Extension.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/03.
//

import UIKit

extension UIButton {
    func alignTextBelow(spacing: CGFloat = 4.0) {
        guard let image = self.imageView?.image else { return }
        guard let titleLabel = self.titleLabel else { return }
        guard let titleText = titleLabel.text else { return }
        
        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font as Any
        ])
        
        titleEdgeInsets = UIEdgeInsets(
            top: spacing,
            left: -image.size.width,
            bottom: -image.size.height,
            right: .zero
        )
        
        imageEdgeInsets = UIEdgeInsets(
            top: -(titleSize.height + spacing),
            left: .zero,
            bottom: .zero,
            right: -titleSize.width
        )
    }
    
    func marginImageWithText(margin: CGFloat) {
        let halfSize = margin / 2
        imageEdgeInsets = UIEdgeInsets(top: .zero, left: -halfSize, bottom: .zero, right: halfSize)
        titleEdgeInsets = UIEdgeInsets(top: .zero, left: halfSize, bottom: .zero, right: -halfSize)
        contentEdgeInsets = UIEdgeInsets(top: .zero, left: halfSize, bottom: .zero, right: halfSize)
    }
}
