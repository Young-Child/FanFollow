//
//  LogOutAlertView.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/14.
//

import UIKit

final class LogOutAlertView: UIView {
    // View Properties
    private let mainLabel = UILabel().then {
        $0.text = Constants.contents
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    private let logOutButton = UIButton().then {
        $0.setTitle(Constants.logOut, for: .normal)
        $0.backgroundColor = UIColor(named: "AccentColor")
        
    }
    
    private let cancelButton = UIButton().then {
        $0.setTitle(Constants.cancel, for: .normal)
        $0.backgroundColor = .lightGray
    }
    
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

// Constants
extension LogOutAlertView {
    enum Constants {
        static let contents = "로그아웃하시겠습니까?"
        static let logOut = "로그아웃"
        static let cancel = "취소"
    }
}
