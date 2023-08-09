//
//  CreatorApplicationStepView.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/02.
//

import UIKit

final class CreatorApplicationStepView: UIStackView {
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .label
        $0.text = "Example"
    }
    
    private let stepStackView = UIStackView().then {
        let childViews = (0...2).map { _ in
            return UIView().then { view in
                view.layer.cornerRadius = 10
                view.backgroundColor = UIColor(named: "SecondaryColor")
            }
        }
        
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
        childViews.forEach($0.addArrangedSubview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureUI()
    }
    
    func configureUI() {
        distribution = .fillProportionally
        axis = .vertical
        layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        spacing = 16
        isLayoutMarginsRelativeArrangement = true
        [titleLabel, stepStackView].forEach(addArrangedSubview)
        
        stepStackView.snp.makeConstraints {
            $0.height.equalTo(20)
        }
    }
    
    func configAppear(currentStep: CreatorApplicationStep) {
        stepStackView.arrangedSubviews.enumerated().forEach { index, view in
            if index <= currentStep.rawValue {
                view.layer.backgroundColor = UIColor(named: "AccentColor")?.cgColor
            }
        }
        
        titleLabel.text = currentStep.title
    }
}
