//
//  SettingTabBarController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift

protocol SettingTabBarDelegate: AnyObject {
    func settingController(_ controller: SettingViewController, removeFeedManageTab isCreator: Bool)
    func settingController(_ controller: SettingViewController, didTapPresent item: SettingSectionItem)
}

final class SettingTabBarController: TopTabBarController<SettingTabItem> {
    private let postButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = .label
        $0.backgroundColor = .clear
    }
    
    weak var coordinator: SettingCoordinator?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindPostButton()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setDelegate() {
        guard let controller = viewControllers?.first as? SettingViewController else { return }
        controller.settingTabBarDelegate = self
    }
}

extension SettingTabBarController: SettingTabBarDelegate {
    func settingController(
        _ controller: SettingViewController,
        removeFeedManageTab isCreator: Bool
    ) {
        guard let itemCount = viewControllers?.count else { return }
        if itemCount <= 1 { return }
        
        let lastIndex = (itemCount - 1)
        viewControllers?.remove(at: lastIndex)
        hideTabBarItem(to: lastIndex)
        view.setNeedsLayout()
    }
    
    func settingController(_ controller: SettingViewController, didTapPresent item: SettingSectionItem) {
        coordinator?.presentSettingDetailController(to: item.presentType)
    }
}

// Binding
private extension SettingTabBarController {
    func bindPostButton() {
        postButton.rx.tap
            .bind { _ in
                self.coordinator?.presentPostBottomViewController()
            }
            .disposed(by: disposeBag)
    }
}

// Configure UI
private extension SettingTabBarController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        view.addSubview(postButton)
    }
    
    func makeConstraints() {
        postButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
