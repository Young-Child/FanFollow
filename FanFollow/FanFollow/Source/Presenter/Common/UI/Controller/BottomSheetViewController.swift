//
//  BottomSheetViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift

final class BottomSheetViewController: UIViewController {
    private let transparentView = UIView().then {
        $0.backgroundColor = .darkGray.withAlphaComponent(0.7)
    }
    
    private let bottomContainerView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    private let childController: UIViewController
    
    init(controller: UIViewController) {
        self.childController = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(didTapDismiss))
        transparentView.addGestureRecognizer(dismissTap)
        transparentView.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        showBottomSheet()
    }
    
    @objc private func didTapDismiss() {
        // TODO: - Coordinator로 dismiss
        self.dismiss(animated: true)
    }
}

extension BottomSheetViewController {
    func showBottomSheet() {
        let height = view.frame.height * 0.4
        bottomContainerView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        
        UIView.animate(withDuration: 0.1) {
            self.transparentView.alpha = 0.4
            self.view.layoutIfNeeded()
        }
    }
}

private extension BottomSheetViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
        self.transparentView.alpha = .zero
    }
    
    func configureHierarchy() {
        addChild(childController)
        bottomContainerView.addSubview(childController.view)
        
        view.addSubview(transparentView)
        view.addSubview(bottomContainerView)
    }
    
    func makeConstraints() {
        transparentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomContainerView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        childController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

class RegisterOutViewController: UIViewController {
    private let titleLabel = UILabel().then {
        $0.text = Constants.Text.withdrawalTitle
        $0.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.textColor = Constants.Color.label
    }
    
    private let noticeLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = Constants.Text.withdrawalNotice
        $0.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.textColor = Constants.Color.label
    }
    
    private let agreeCheckButton = UIButton().then {
        $0.tintColor = Constants.Color.blue
        $0.setImage(Constants.Image.checkMark, for: .selected)
        $0.setImage(Constants.Image.square, for: .normal)
    }
    
    private let agreeLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = Constants.Color.gray
        $0.text = Constants.Text.withdrawalAgree
        $0.font = .coreDreamFont(ofSize: 14, weight: .regular)
    }
    
    private let agreeStackView = UIStackView().then {
        $0.spacing = 8
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    private let withdrawalButton = UIButton().then {
        $0.isEnabled = false
        $0.layer.cornerRadius = 4
        $0.setTitle(Constants.Text.withdrawal, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = Constants.Color.gray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// Configure UI
private extension RegisterOutViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [agreeCheckButton, agreeLabel].forEach(agreeStackView.addArrangedSubview(_:))
        [titleLabel, noticeLabel, agreeStackView, withdrawalButton].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(Constants.Spacing.medium)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.medium)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        agreeStackView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.trailing.equalTo(noticeLabel)
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(agreeStackView.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.trailing.equalTo(agreeStackView)
            $0.bottom.equalToSuperview().offset(-Constants.Spacing.large)
        }
    }
}
