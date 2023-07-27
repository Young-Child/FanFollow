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
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .label
        $0.backgroundColor = .clear
    }
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind()
    }
}

// Binding
private extension ExploreTabBarController {
    func bind() {
        // 화면 이동 임시 구현
        searchButton.rx.tap
            .bind { _ in
                let searchViewModel = ExploreSearchViewModel(
                    searchCreatorUseCase: DefaultSearchCreatorUseCase(
                        userInformationRepository: DefaultUserInformationRepository(
                            DefaultNetworkService()
                        )
                    )
                )
                let viewController = ExploreSearchViewController(viewModel: searchViewModel)
                self.navigationController?.pushViewController(viewController, animated: true)
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
