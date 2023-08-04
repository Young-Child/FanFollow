//
//  CreatorApplicationStepView.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/02.
//

import UIKit

final class CreatorApplicationStepView: UIView {
    // View Properties
    private let stackView = UIStackView().then { stackView in
        stackView.spacing = 16
        stackView.axis = .vertical
    }

    private let titleLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 24, weight: .bold)
    }

    private let stepStackView = UIStackView(
        arrangedSubviews: (0...2).map { _ in
            return UIView().then { view in
                view.backgroundColor = UIColor(named: "SecondaryColor")
                view.layer.cornerRadius = 8
            }
        }
    ).then { stackView in
        stackView.distribution = .fillEqually
    }

    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ creatorApplicationStep: CreatorApplicationStep) {
        titleLabel.text = creatorApplicationStep.title
        stepStackView.subviews.enumerated().forEach { (index, view) in
            let isFill = index < creatorApplicationStep.steps
            view.backgroundColor = isFill ? UIColor(named: "AccentColor") : UIColor(named: "SecondaryColor")
        }
    }
}

private extension CreatorApplicationStepView {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
    }

    func configureHierarchy() {
        [titleLabel, stepStackView].forEach(stackView.addArrangedSubview)
        addSubview(stackView)
    }

    func configureConstraints() {
        stepStackView.snp.makeConstraints {
            $0.height.equalTo(16)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}

private extension CreatorApplicationStep {
    var title: String {
        switch self {
        case .back:
            return ""
        case .category:
            return "분야 설정"
        case .links:
            return "링크 설정"
        case .introduce:
            return "소개 설정"
        }
    }

    var steps: Int {
        switch self {
        case .back:
            return 0
        case .category:
            return 1
        case .links:
            return 2
        case .introduce:
            return 3
        }
    }
}
