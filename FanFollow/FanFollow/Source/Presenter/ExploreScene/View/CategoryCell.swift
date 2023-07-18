//
//  CategoryCell.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/17.
//

import UIKit
import SnapKit

final class CategoryCell: UICollectionViewCell {
    // View Properties
    private let categoryLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "AccentColor")
        $0.backgroundColor = UIColor(named: "CategoryCellColor")
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        categoryLabel.layer.cornerRadius = 10
        categoryLabel.clipsToBounds = true
    }
}

// UI Method
extension CategoryCell {
    func configureCell(jobCategory: JobCategory) {
        categoryLabel.text = jobCategory.categoryName
    }
}

// Configure UI
private extension CategoryCell {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        contentView.addSubview(categoryLabel)
    }
    
    func makeConstraints() {
        categoryLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}
