//
//  CreatorCell.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/17.
//

import UIKit

final class CreatorCell: UICollectionViewCell {
    // View Properties
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor(named: "SecondaryColor")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let nickNameLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "AccentColor")
        $0.font = .preferredFont(forTextStyle: .body)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
