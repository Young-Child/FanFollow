//
//  SettingTabBarController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift

protocol SettingTabBarDelegate: AnyObject {
    func settingController(_ controller: SettingViewController, removeFeedManageTab isCreator: Bool)
    func settingController(
        _ controller: SettingViewController,
        didTapPresent item: SettingSectionItem
    )
    func settingController(_ controller: ProfileFeedViewController, didTapEdit item: Post)
}

final class SettingTabBarController: TopTabBarController<SettingTabItem> {
    private let uploadButton = UIButton().then {
        $0.setImage(Constants.Image.plus, for: .normal)
        $0.tintColor = Constants.Color.label
        $0.backgroundColor = Constants.Color.clear
    }
    
    override var selectedIndex: Int {
        willSet {
            let buttonHidden = newValue == .zero
            uploadButton.isHidden = buttonHidden
        }
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
        viewControllers?.forEach { controller in
            if let controller = controller as? SettingViewController {
                controller.settingTabBarDelegate = self
            }
            
            if let controller = controller as? ProfileFeedViewController {
                controller.settingDelegate = self
            }
        }
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
        
        if isCreator == true {
            showTabBarItem(to: lastIndex)
        }
        
        if isCreator == false {
            hideTabBarItem(to: lastIndex)
        }
    }
    
    func settingController(
        _ controller: SettingViewController,
        didTapPresent item: SettingSectionItem
    ) {
        coordinator?.presentSettingDetailController(to: item.presentType)
    }
    
    func settingController(_ controller: ProfileFeedViewController, didTapEdit item: Post) {
        coordinator?.presentEditPostViewController(post: item)
    }
}

// Binding
private extension SettingTabBarController {
    func bindPostButton() {
        uploadButton.rx.tap
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
        view.addSubview(uploadButton)
    }
    
    func makeConstraints() {
        uploadButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.Spacing.small)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.medium)
        }
    }
}
