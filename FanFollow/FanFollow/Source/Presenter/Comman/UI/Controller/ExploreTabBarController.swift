//
//  ExploreTabBarController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/18.
//

import UIKit

import RxSwift

protocol ExploreCreatorDelegate: AnyObject {
    func exploreViewController(_ controller: ExploreViewController, didTapPresent item: ExploreSectionItem)
}

final class ExploreTabBarController: TopTabBarController<ExploreTapItem> {
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
        setExplorCoordinator()
    }
    
    private func setExplorCoordinator() {
        viewControllers?.forEach { controller in
            if let controller = controller as? ExploreViewController {
                controller.delegate = self
            }
        }
    }
}

extension ExploreTabBarController: ExploreCreatorDelegate {
    func exploreViewController(_ controller: ExploreViewController, didTapPresent item: ExploreSectionItem) {
        switch item {
        case .category(let job):
            coordinator?.presentCategoryViewController(for: job)
        case .creator(_, let creatorID, _):
            coordinator?.presentProfileViewController(to: creatorID)
        }
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
