//
//  UploadImageCell.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import UIKit

import RxSwift

protocol UploadImageCellDelegate: AnyObject {
    func uploadImageCell(didTapPickImage cell: UploadImageCell)
    func uploadImageCell(didTapRemoveImage cell: UploadImageCell)
}

final class UploadImageCell: UICollectionViewCell {
    // View Property
    private let imageStackView = UIStackView().then {
        $0.alignment = .fill
    }
    
    private let deleteButton = UIButton().then {
        $0.tintColor = Constants.Color.background
        $0.backgroundColor = Constants.Color.warningColor
        
        $0.setImage(Constants.Image.xmark, for: .normal)
    }
    
    private let pickerButton = UIButton().then {
        $0.tintColor = Constants.Color.label
        $0.backgroundColor = Constants.Color.gray
        $0.setImage(Constants.Image.plus, for: .normal)
    }
    
    // Property
    weak var pickerDelegate: UploadImageCellDelegate?
    private let disposeBag = DisposeBag()
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        deleteButton.layer.cornerRadius = deleteButton.bounds.size.width / 2
        deleteButton.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func configure(with isButton: Bool, image: UIImage? = nil) {
        func createButton() {
            let pickingAction = UIAction { _ in
                self.pickerDelegate?.uploadImageCell(didTapPickImage: self)
            }
            pickerButton.addAction(pickingAction, for: .touchUpInside)
            imageStackView.addArrangedSubview(pickerButton)
            deleteButton.isHidden = true
        }
        
        func configureCell(_ image: UIImage?) {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            
            imageStackView.addArrangedSubview(imageView)
            
            let deleteAction = UIAction { _ in
                self.pickerDelegate?.uploadImageCell(didTapRemoveImage: self)
            }
            deleteButton.addAction(deleteAction, for: .touchUpInside)
            deleteButton.isHidden = false
        }
        
        if isButton == true {
            createButton()
            return
        }
        
        if isButton == false {
            configureCell(image)
        }
    }
}

// Configure UI
private extension UploadImageCell {
    func configureUI() {
        backgroundColor = Constants.Color.background
        
        configureLayer()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureLayer() {
        layer.cornerRadius = Constants.Spacing.xSmall
        layer.borderWidth = 1
        layer.borderColor = Constants.Color.gray.cgColor
        clipsToBounds = true
    }
    
    func configureHierarchy() {
        [imageStackView, deleteButton].forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        imageStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(Constants.Spacing.small)
            $0.width.height.equalTo(contentView.snp.width).multipliedBy(0.13)
        }
    }
}
