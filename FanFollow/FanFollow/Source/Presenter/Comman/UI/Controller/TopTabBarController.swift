//
//  TopTapBarController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift

class TopTabBarController<T: TabItem>: UITabBarController {
    private let customTabBar = TabBar(tabItems: Array(T.allCases))
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTopTabBar()
        configureChildViewControllers(items: Array(T.allCases))
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewControllers?.forEach {
            if $0.additionalSafeAreaInsets.top != .zero { return }
            $0.additionalSafeAreaInsets.top += customTabBar.frame.height
        }
        
        view.setNeedsLayout()
    }
    
    private func configureTopTabBar() {
        tabBar.isHidden = true
        
        view.addSubview(customTabBar)
        
        customTabBar.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    private func configureChildViewControllers(items: [T]) {
        let controllers = items.map { $0.viewController }
        setViewControllers(controllers, animated: true)
    }
    
    private func bind() {
        customTabBar.itemTapped
            .bind { [weak self] in self?.selectedIndex = $0 }
            .disposed(by: disposeBag)
    }
}
