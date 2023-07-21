//
//  UICollectionView+Extension.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/18.
//

import UIKit

extension UICollectionView {
    func dequeueReuseableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            return T()
        }
        
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        forIndexPath indexPath: IndexPath,
        kind: String
    ) -> T {
        guard let headerView = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            return T()
        }
        
        return headerView
    }
}
