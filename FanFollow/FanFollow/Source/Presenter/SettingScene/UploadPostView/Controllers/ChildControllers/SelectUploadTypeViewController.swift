//
//  SelectUploadTypeViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/01.
//

import UIKit

import RxSwift

final class SelectUploadTypeViewController: UIViewController {
    // View Properties
    private let titleLabel = UILabel().then {
        $0.text = Constants.Text.uploadTitle
        $0.font = .coreDreamFont(ofSize: 16, weight: .medium)
        $0.textColor = Constants.Color.label
    }
    
    private let photoButton = UIButton().then {
        $0.titleLabel?.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.tintColor = Constants.Color.label
        $0.layer.cornerRadius = 4
        $0.setTitle(Constants.Text.photo, for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = Constants.Color.gray
        $0.setImage(Constants.Image.photo, for: .normal)
    }
    
    private let linkButton = UIButton().then {
        $0.titleLabel?.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.tintColor = .label
        $0.layer.cornerRadius = 4
        $0.setTitle(Constants.Text.link, for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = Constants.Color.gray
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
        $0.setTitle(Constants.Text.cancel, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = Constants.Color.blue
    }
    
    // Property
    weak var coordinator: UploadCoordinator?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        buttonBind()
    }
    
    private func buttonBind() {
        photoButton.rx.tap
            .bind { _ in
                self.closeBottomSheet()
                self.coordinator?.presentPostViewController(type: .photo)
            }
            .disposed(by: disposeBag)
        
        linkButton.rx.tap
            .bind { _ in
                self.closeBottomSheet()
                self.coordinator?.presentPostViewController(type: .link)
            }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind { self.closeBottomSheet() }
            .disposed(by: disposeBag)
    }
    
    private func closeBottomSheet() {
        guard let parent = self.parent else { return }
        self.coordinator?.close(to: parent)
    }
}

// Configure UI
private extension SelectUploadTypeViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
        
        [photoButton, linkButton].forEach { $0.alignTextBelow() }
    }
    
    func configureHierarchy() {
        [photoButton, linkButton].forEach(buttonStackView.addArrangedSubview(_:))
        [titleLabel, buttonStackView, cancelButton].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(Constants.Spacing.medium)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(buttonStackView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
