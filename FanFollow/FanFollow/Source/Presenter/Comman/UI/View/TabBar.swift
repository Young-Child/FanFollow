//
//  UITabBar.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxCocoa
import RxRelay
import RxSwift

class TabBar: UIStackView {
    private var tabButtons = [UIButton]()
    private let itemTappedSubject = BehaviorSubject(value: 0)
    private let disposeBag = DisposeBag()
    
    var itemTapped: Observable<Int> {
        return itemTappedSubject.asObservable()
    }
    
    init(tabItems: [any TabItem]) {
        super.init(frame: .zero)
        setUpViews(with: tabItems)
        selectItem(index: 0)
        setUpDetail()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func selectItem(index: Int) {
        tabButtons.enumerated()
            .forEach { $0.element.isSelected = ($0.offset == index )}
        itemTappedSubject.onNext(index)
    }
    
    func hideItem(index: Int) {
        tabButtons[index].isHidden = true
    }
}

// MARK: - Configure UI
private extension TabBar {
    func generateButton(item: any TabItem) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(item.description, for: .normal)
            $0.setTitleColor(Constants.Color.grayDark, for: .normal)
            $0.setTitleColor(Constants.Color.blue, for: .selected)
            $0.titleLabel?.font = .coreDreamFont(ofSize: 28, weight: .bold)
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
    
    func setUpDetail() {
        spacing = Constants.Spacing.medium
        distribution = .fill
        axis = .horizontal
    }
}
