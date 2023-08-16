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
        $0.font = .coreDreamFont(ofSize: 28, weight: .bold)
        $0.textColor = .label
    }
    
    private let stepStackView = UIStackView().then {
        let childViews = (0...2).map { _ in
            return UIView().then { view in
                view.backgroundColor = Constants.Color.grayDark
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
            let backgroundColor = (index <= currentStep.rawValue) ? Constants.Color.blue : Constants.Color.gray
            UIView.animate(withDuration: 0.25) {
                view.backgroundColor = backgroundColor
            }
        }
        
        titleLabel.text = currentStep.title
    }
}
