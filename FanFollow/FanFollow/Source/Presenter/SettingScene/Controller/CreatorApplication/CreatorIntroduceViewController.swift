//
//  CreatorIntroduceViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/03.
//

import UIKit
import RxSwift
import RxCocoa

final class CreatorIntroduceViewController: UIViewController {
    private let introduceTextView = PlaceholderTextView().then { textView in
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.placeholder = Constants.introduceInputViewPlaceholder
    }

    var updatedIntroduce: Observable<String?> {
        return introduceTextView.rx.text.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(introduceTextView)
        introduceTextView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

private extension CreatorIntroduceViewController {
    enum Constants {
        static let introduceInputViewPlaceholder = "소개글을 작성해주세요."
    }
}
