//
//  ExploreTabBarController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/18.
//

import UIKit

import RxSwift

final class ExploreTabBarController: TopTabBarController<ExploreTapItem> {
    private let searchButton = UIButton().then {
        $0.setImage(Constants.Image.magnifyingGlass, for: .normal)
        $0.tintColor = .label
        $0.backgroundColor = .clear
    }
    
    weak var coordinator: ExploreCoordinator?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindSearchButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setExplorCoordinator()
    }
    
    private func setExplorCoordinator() {
        viewControllers?.forEach({ viewController in
            if let controller = viewController as? ExploreViewController {
                controller.coordinator = self.coordinator
            } else if let controller = viewController as? ExploreSubscribeViewController {
                controller.coordinator = self.coordinator
            }
        })
    }
}

// Binding
private extension ExploreTabBarController {
    func bindSearchButton() {
        searchButton.rx.tap
            .bind { _ in
                self.coordinator?.presentSearchViewController()
            }
            .disposed(by: disposeBag)
    }
}

// Configure UI
private extension ExploreTabBarController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        view.addSubview(searchButton)
    }
    
    func makeConstraints() {
        searchButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
