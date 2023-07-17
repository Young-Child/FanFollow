//
//  CategoryCell.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/17.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    // View Properties
    private let categoryLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "AccentColor")
        $0.backgroundColor = UIColor(named: "SecondaryColor")
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
