//
//  PostBottomSheetView.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import UIKit

final class PostBottomSheetView: UIView {
    // View Properties
    private let titleLabel = UILabel().then {
        $0.text = "게시물 업로드"
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .black
    }
    
    private let photoButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.setTitle("사진", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .systemGray6
        $0.setImage(UIImage(systemName: "photo.fill.on.rectangle.fill"), for: .normal)
    }
    
    private let linkButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.setTitle("링크", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .systemGray6
        $0.setImage(UIImage(systemName: "link.badge.plus"), for: .normal)
    }
    
    private let buttonStackView = UIStackView().then {
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .horizontal
    }
    
    private let cancelButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "AccentColor")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Configure UI
private extension PostBottomSheetView {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }

    func configureHierarchy() {
        [photoButton, linkButton].forEach(buttonStackView.addArrangedSubview(_:))
        [titleLabel, buttonStackView, cancelButton].forEach(addSubview(_:))
    }

    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.height.equalTo(30)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(self.snp.height).multipliedBy(0.4)
            $0.trailing.equalToSuperview().offset(-16)
        }

        cancelButton.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
    }
}
