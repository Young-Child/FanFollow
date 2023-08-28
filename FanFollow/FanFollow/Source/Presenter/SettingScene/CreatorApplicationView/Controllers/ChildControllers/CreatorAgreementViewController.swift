//
//  CreatorAgreementViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/28.
//

import UIKit

final class CreatorAgreementViewController: CreatorApplicationChildController {
    private let agreeTextView = UnderLineTextView().then {
        $0.textView.isEditable = false
        $0.textView.text = Constants.Text.creatorAgreementInformation
        $0.textView.font = .coreDreamFont(ofSize: 14, weight: .regular)
    }
    
    private let agreeCheckButton = UIButton().then {
        $0.tintColor = Constants.Color.blue
        $0.setImage(Constants.Image.checkMark, for: .selected)
        $0.setImage(Constants.Image.square, for: .normal)
    }
    
    private let agreeLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = Constants.Color.gray
        $0.text = Constants.Text.creatorAgreement
        $0.font = .coreDreamFont(ofSize: 17, weight: .regular)
    }
    
    private let agreeStackView = UIStackView().then {
        $0.spacing = 8
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

private extension CreatorAgreementViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [agreeCheckButton, agreeLabel].forEach(agreeStackView.addArrangedSubview(_:))
        [agreeTextView, agreeStackView].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        agreeTextView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(Constants.Spacing.small)
        }
        
        agreeStackView.snp.makeConstraints {
            $0.top.equalTo(agreeTextView.snp.bottom).offset(Constants.Spacing.medium)
            $0.centerX.equalToSuperview()
        }
    }
}
