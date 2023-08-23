//
//  ExploreTabBarController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/18.
//

import UIKit

import RxSwift

protocol ExploreCreatorDelegate: AnyObject {
    func exploreViewController(
        _ controller: ExploreViewController,
        didTapPresent item: ExploreSectionItem
    )
}

protocol ExploreSubscribeDelegate: AnyObject {
    func exploreViewController(
        _ controller: ExploreSubscribeViewController,
        didTapPresent item: Creator
    )
}

final class ExploreTabBarController: TopTabBarController<ExploreTabItem> {
    private let searchButton = UIButton().then {
        $0.setImage(Constants.Image.magnifyingGlass, for: .normal)
        $0.tintColor = Constants.Color.label
        $0.backgroundColor = Constants.Color.clear
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
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        setExploreCoordinator()
    }
    
    private func setExploreCoordinator() {
        viewControllers?.forEach { controller in
            if let controller = controller as? ExploreViewController {
                controller.delegate = self
            }
            
            if let controller = controller as? ExploreSubscribeViewController {
                controller.delegate = self
            }
        }
    }
}

// To Profile From ExploreScene
extension ExploreTabBarController: ExploreCreatorDelegate {
    func exploreViewController(
        _ controller: ExploreViewController,
        didTapPresent item: ExploreSectionItem
    ) {
        switch item {
        case .category(let job):
            coordinator?.presentCategoryViewController(for: job)
        case .creator(_, let creatorID, _):
            coordinator?.presentProfileViewController(to: creatorID)
        }
    }
}

// To Profile From ExploreSubscribeScene
extension ExploreTabBarController: ExploreSubscribeDelegate {
    func exploreViewController(
        _ controller: ExploreSubscribeViewController,
        didTapPresent item: Creator
    ) {
        coordinator?.presentProfileViewController(to: item.id)
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
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.Spacing.small)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.medium)
        }
    }
}
