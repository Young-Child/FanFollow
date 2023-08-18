//
//  WithdrawalBottomSheetView.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

import RxCocoa
import RxSwift

final class WithdrawalBottomSheetView: UIView {
    // View Properties
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
    
    // Property
    var didTapWithdrawalButton: ControlEvent<Void> {
        return withdrawalButton.rx.controlEvent(.touchUpInside)
    }
    private let disposeBag = DisposeBag()
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Binding
private extension WithdrawalBottomSheetView {
    func binding() {
        agreeCheckButton.rx.tap
            .bind {
                self.agreeCheckButton.isSelected = !self.agreeCheckButton.isSelected
                if self.agreeCheckButton.isSelected {
                    self.enableWithdrawal()
                } else {
                    self.disenableWithdrawal()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func enableWithdrawal() {
        agreeLabel.textColor = Constants.Color.label
        withdrawalButton.isEnabled = true
        withdrawalButton.backgroundColor = Constants.Color.warningColor
    }
    
    func disenableWithdrawal() {
        agreeLabel.textColor = Constants.Color.gray
        withdrawalButton.isEnabled = false
        withdrawalButton.backgroundColor = .lightGray
    }
}

// Configure UI
private extension WithdrawalBottomSheetView {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [agreeCheckButton, agreeLabel].forEach(agreeStackView.addArrangedSubview(_:))
        [titleLabel, noticeLabel, agreeStackView, withdrawalButton].forEach(addSubview(_:))
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
