//
//  ExploreTabBarController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/18.
//

import UIKit

final class ExploreTabBarController: TopTabBarController<ExploreTapItem> {
    private let searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .label
        $0.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// Action
private extension ExploreTabBarController {
    @objc private func searchButtonTapped() {
        //TODO: - 추후 구현
    }
}

// Configure UI
private extension ExploreTabBarController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
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