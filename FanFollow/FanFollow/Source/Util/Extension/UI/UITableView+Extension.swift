//
//  UITableView+Extension.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            return T()
        }
        
        return cell
    }
}
