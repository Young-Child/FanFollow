//
//  WithdrawalBottomSheetView.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

import RxSwift

protocol WithdrawalSheetButtonDelegate: AnyObject {
    func withdrawalButtonTapped()
}

final class WithdrawalBottomSheetView: UIView {
    // View Properties
    private let titleLabel = UILabel().then {
        $0.text = Constants.title
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .black
    }
    
    private let noticeLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = Constants.notice
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .black
    }
    
    private let agreeCheckButton = UIButton().then {
        $0.tintColor = UIColor(named: "AccentColor")
        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        $0.setImage(UIImage(systemName: "square"), for: .normal)
    }
    
    private let agreeLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .lightGray
        $0.text = Constants.agree
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    
    private let agreeStackView = UIStackView().then {
        $0.spacing = 8
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    private let withdrawalButton = UIButton().then {
        $0.isEnabled = false
        $0.layer.cornerRadius = 10
        $0.setTitle(Constants.withdrawal, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .lightGray
    }
    
    // Property
    private let disposeBag = DisposeBag()
    weak var withdrawalDelegate: WithdrawalSheetButtonDelegate?
    
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
        
        withdrawalButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind {
                self.withdrawalDelegate?.withdrawalButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    func enableWithdrawal() {
        agreeLabel.textColor = .label
        withdrawalButton.isEnabled = true
        withdrawalButton.backgroundColor = UIColor(named: "AlertColor")
    }
    
    func disenableWithdrawal() {
        agreeLabel.textColor = .lightGray
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
            $0.top.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        agreeStackView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.top.equalTo(agreeStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(40)
        }
    }
}

extension WithdrawalBottomSheetView {
    enum Constants {
        static let title = "회원탈퇴"
        static let notice = "탈퇴 시, 회원 정보 및 모든 서비스의 이용내역이 삭제됩니다. 삭제된 데이터는 복구가 불가능합니다."
        static let agree = "회원탈퇴에 관한 모든 내용을 숙지하였고, 회원탈퇴를 신청합니다."
        static let withdrawal = "회원탈퇴하기"
    }
}
