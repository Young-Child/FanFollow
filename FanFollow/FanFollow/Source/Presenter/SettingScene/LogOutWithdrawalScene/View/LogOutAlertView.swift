//
//  LogOutAlertView.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

import RxCocoa
import RxSwift

final class LogOutAlertView: UIView {
    // View Properties
    private let mainLabel = UILabel().then {
        $0.text = Constants.Text.logOutAlertMessage
        $0.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.textColor = Constants.Color.label
    }
    
    private let logOutButton = UIButton().then {
        $0.setTitle(Constants.Text.logOut, for: .normal)
        $0.backgroundColor = Constants.Color.blue
        $0.titleLabel?.font = .coreDreamFont(ofSize: 14, weight: .regular)
    }
    
    private let cancelButton = UIButton().then {
        $0.setTitle(Constants.Text.cancel, for: .normal)
        $0.backgroundColor = Constants.Color.grayDark
        $0.titleLabel?.font = .coreDreamFont(ofSize: 14, weight: .regular)
    }
    
    // Property
    var didTapLogOutButton: ControlEvent<Void> {
        return logOutButton.rx.controlEvent(.touchUpInside)
    }
    var didTapCancelButton: ControlEvent<Void> {
        return cancelButton.rx.controlEvent(.touchUpInside)
    }
    private let disposeBag = DisposeBag()
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Configure UI
private extension LogOutAlertView {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [mainLabel, logOutButton, cancelButton].forEach(addSubview(_:))
    }
    
    func makeConstraints() {
        mainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Spacing.large)
            $0.centerX.equalTo(snp.centerX)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(snp.centerX)
            $0.bottom.equalToSuperview()
        }
        
        logOutButton.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.equalTo(snp.centerX)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
