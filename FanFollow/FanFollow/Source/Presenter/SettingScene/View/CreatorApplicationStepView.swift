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

//final class CreatorApplicationStepView: UIView {
//    // View Properties
//    private let stackView = UIStackView().then { stackView in
//        stackView.spacing = 16
//        stackView.axis = .vertical
//    }
//
//    private let titleLabel = UILabel().then { label in
//        label.numberOfLines = 1
//        label.font = .systemFont(ofSize: 24, weight: .bold)
//    }
//
//    private let stepStackView = UIStackView(
//        arrangedSubviews: (0...2).map { _ in
//            return UIView().then { view in
//                view.backgroundColor = UIColor(named: "SecondaryColor")
//                view.layer.cornerRadius = 8
//            }
//        }
//    ).then { stackView in
//        stackView.axis = .horizontal
//        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.spacing = 8
//        stackView.distribution = .fillEqually
//    }
//
//    // Initializer
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func configure(_ creatorApplicationStep: CreatorApplicationStep) {
//        titleLabel.text = creatorApplicationStep.title
//        stepStackView.subviews.enumerated().forEach { (index, view) in
//            let isFill = index < creatorApplicationStep.steps
//            view.backgroundColor = isFill ? UIColor(named: "AccentColor") : UIColor(named: "SecondaryColor")
//        }
//    }
//}
//
//private extension CreatorApplicationStepView {
//    func configureUI() {
//        configureHierarchy()
//        configureConstraints()
//    }
//
//    func configureHierarchy() {
//        [titleLabel, stepStackView].forEach(stackView.addArrangedSubview)
//        addSubview(stackView)
//    }
//
//    func configureConstraints() {
//        stepStackView.snp.makeConstraints {
//            $0.height.equalTo(16)
//        }
//        stackView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
//}

//private extension CreatorApplicationStep {
//    var title: String {
//        switch self {
//        case .category:
//            return "분야 설정"
//        case .links:
//            return "링크 설정"
//        case .introduce:
//            return "소개 설정"
//        }
//    }
//
//    var steps: Int {
//        switch self {
//        case .category:
//            return 1
//        case .links:
//            return 2
//        case .introduce:
//            return 3
//        }
//    }
//}
