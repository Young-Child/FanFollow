//
//  CreatorAgreementViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/28.
//

import UIKit

import RxCocoa
import RxSwift

final class CreatorAgreementViewController: CreatorApplicationChildController {
    private let agreeTextView = UITextView().then {
        $0.isEditable = false
        $0.text = Constants.Text.creatorAgreementInformation
        $0.font = .coreDreamFont(ofSize: 14, weight: .regular)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        nextButtonEnable.accept(true)
    }
}

private extension CreatorAgreementViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        view.addSubview(agreeTextView)
    }
    
    func makeConstraints() {
        agreeTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.Spacing.medium)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.medium)
        }
    }
}
