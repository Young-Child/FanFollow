//
//  UploadImageCell.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import UIKit
import RxSwift

protocol UploadImageCellDelegate: AnyObject {
    func uploadImageCell()
}

final class UploadImageCell: UICollectionViewCell {
    // View Property
    private let imageStackView = UIStackView().then {
        $0.alignment = .fill
    }
    
    private let pickerButton = UIButton().then {
        $0.tintColor = .label
        $0.backgroundColor = .systemGray5
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    // Property
    weak var pickerDelegate: UploadImageCellDelegate?
    private let disposeBag = DisposeBag()
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createButton() {
        imageStackView.addArrangedSubview(pickerButton)
    }
    
    func configureCell(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
    
        imageStackView.addArrangedSubview(imageView)
    }
}

// Bind
private extension UploadImageCell {
    func bind() {
        pickerButton.rx.tap
            .bind {
                self.pickerDelegate?.uploadImageCell()
            }
            .disposed(by: disposeBag)
    }
}

// Configure UI
private extension UploadImageCell {
    func configureUI() {
        backgroundColor = .white
        
        configureLayer()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureLayer() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    func configureHierarchy() {
        contentView.addSubview(imageStackView)
    }
    
    func makeConstraints() {
        imageStackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(contentView)
        }
    }
}
