//
//  LogOutAlertView.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

import RxSwift

protocol LogOutViewButtonDelegate: AnyObject {
    func logOutButtonTapped()
    func cancelButtonTapped()
}

final class LogOutAlertView: UIView {
    // View Properties
    private let mainLabel = UILabel().then {
        $0.text = Constants.Text.logOutAlertMessage
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = Constants.Color.label
    }
    
    private let logOutButton = UIButton().then {
        $0.setTitle(Constants.Text.logOut, for: .normal)
        $0.backgroundColor = Constants.Color.blue
        
    }
    
    private let cancelButton = UIButton().then {
        $0.setTitle(Constants.Text.cancel, for: .normal)
        $0.backgroundColor = .lightGray
    }
    
    // Property
    private let disposeBag = DisposeBag()
    weak var logOutViewButtonDelegate: LogOutViewButtonDelegate?
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        buttinBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Binding
    private func buttinBind() {
        cancelButton.rx.tap
            .bind { _ in
                self.logOutViewButtonDelegate?.cancelButtonTapped()
            }
            .disposed(by: disposeBag)
        
        logOutButton.rx.tap
            .bind { _ in
                self.logOutViewButtonDelegate?.logOutButtonTapped()
            }
            .disposed(by: disposeBag)
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
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalTo(snp.centerX)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(snp.centerX)
            $0.bottom.equalToSuperview()
        }
        
        logOutButton.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(20)
            $0.leading.equalTo(snp.centerX)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
