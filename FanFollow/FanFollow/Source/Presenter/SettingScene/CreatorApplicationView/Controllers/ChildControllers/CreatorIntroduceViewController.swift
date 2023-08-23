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
        textView.font = .coreDreamFont(ofSize: 14, weight: .regular)
        textView.placeholder = Constants.Text.introduceInputViewPlaceholder
    }
    
    var writtenIntroduce: Observable<String> {
        introduceTextView.rx.text.orEmpty.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(introduceTextView)
        introduceTextView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(Constants.Spacing.small)
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
