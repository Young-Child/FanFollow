//
//  CreatorIntroduceViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/03.
//

import UIKit

import RxCocoa
import RxSwift

final class CreatorIntroduceViewController: CreatorApplicationChildController {
    private let introduceTextView = PlaceholderTextView().then { textView in
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.placeholder = Constants.introduceInputViewPlaceholder
    }
    
    var writtenIntroduce: Observable<String> {
        get {
            introduceTextView.rx.text.orEmpty.asObservable()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(introduceTextView)
        introduceTextView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
        }
        
        bind()
    }
    
    private func bind() {
        introduceTextView.rx.text.orEmpty
            .map { $0.isEmpty == false }
            .bind(to: nextButtonEnable)
            .disposed(by: disposeBag)
    }
}

private extension CreatorIntroduceViewController {
    enum Constants {
        static let introduceInputViewPlaceholder = "소개글을 작성해주세요."
    }
}
