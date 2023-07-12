//
//  UITabBar.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class TabBar: UIStackView {
    private var tabButtons = [UIButton]()
    private let itemTappedSubject = BehaviorSubject(value: 0)
    private let disposeBag = DisposeBag()
    
    var itemTapped: Observable<Int> {
        return itemTappedSubject.asObservable()
    }
    
    init(tabItems: [any TabItem]) {
        super.init(frame: .zero)
        spacing = 16
        distribution = .equalSpacing
        
        setUpViews(with: tabItems)
        selectItem(index: 0)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func selectItem(index: Int) {
        tabButtons.enumerated()
            .forEach { $0.element.isSelected = ($0.offset == index )}
        itemTappedSubject.onNext(index)
    }
}

// MARK: - Configure UI
private extension TabBar {
    func generateButton(item: any TabItem) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(item.description, for: .normal)
            $0.setTitleColor(.secondaryLabel, for: .normal)
            $0.setTitleColor(.blue, for: .selected)
            $0.titleLabel?.font = .systemFont(ofSize: 28, weight: .black)
        }
        
        return button
    }
    
    func setUpViews(with items: [any TabItem]) {
        tabButtons = items.map(generateButton)
        
        tabButtons.enumerated().forEach { [weak self] (index, button) in
            let action = UIAction { _ in
                self?.selectItem(index: index)
            }
            button.addAction(action, for: .touchUpInside)
        }
        
        tabButtons.forEach { addArrangedSubview($0) }
    }
}
