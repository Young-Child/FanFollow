//
//  UploadBottomSheetView.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import UIKit

import RxSwift

protocol SheetButtonDelegate: AnyObject {
    func photoButtonTapped()
    func linkButtonTapped()
    func cancelButtonTapped()
}

final class UploadBottomSheetView: UIView {
    // View Properties
    private let titleLabel = UILabel().then {
        $0.text = ConstantsUploadBottom.title
        $0.font = .coreDreamFont(ofSize: 16, weight: .medium)
        $0.textColor = .black
    }
    
    private let photoButton = UIButton().then {
        $0.titleLabel?.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.tintColor = .label
        $0.layer.cornerRadius = 4
        $0.setTitle(ConstantsUploadBottom.photo, for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .systemGray6
        $0.setImage(Constants.Image.photo, for: .normal)
    }
    
    private let linkButton = UIButton().then {
        $0.titleLabel?.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.tintColor = .label
        $0.layer.cornerRadius = 4
        $0.setTitle(ConstantsUploadBottom.link, for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .systemGray6
        $0.setImage(Constants.Image.link, for: .normal)
    }
    
    private let buttonStackView = UIStackView().then {
        $0.spacing = 4
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .horizontal
    }
    
    private let cancelButton = UIButton().then {
        $0.titleLabel?.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.layer.cornerRadius = 4
        $0.setTitle(ConstantsUploadBottom.cancel, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = Constants.Color.blue
    }
    
    // Property
    weak var buttonDelegate: SheetButtonDelegate?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        buttonBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Binding
    private func buttonBind() {
        photoButton.rx.tap
            .bind { _ in
                self.buttonDelegate?.photoButtonTapped()
            }
            .disposed(by: disposeBag)
        
        linkButton.rx.tap
            .bind { _ in
                self.buttonDelegate?.linkButtonTapped()
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind { _ in
                self.buttonDelegate?.cancelButtonTapped()
            }
            .disposed(by: disposeBag)
    }
}

// Configure UI
private extension UploadBottomSheetView {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
        
        [photoButton, linkButton].forEach { $0.alignTextBelow() }
    }
    
    func configureHierarchy() {
        [photoButton, linkButton].forEach(buttonStackView.addArrangedSubview(_:))
        [titleLabel, buttonStackView, cancelButton].forEach(addSubview(_:))
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalToSuperview().multipliedBy(0.35)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(buttonStackView)
            $0.height.equalTo(40)
        }
    }
}

extension UploadBottomSheetView {
    enum ConstantsUploadBottom {
        static let title = "게시물 업로드"
        static let photo = "사진"
        static let link = "링크"
        static let cancel = "취소"
    }
}
