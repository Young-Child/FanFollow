//
//  ExploreSubscribeViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/28.
//

import UIKit
import RxSwift

final class ExploreSubscribeViewController: UIViewController {
    // View Property
    private let subscribeTableView = UITableView().then {
        $0.separatorColor = .lightGray
        $0.backgroundColor = .clear
        $0.register(CreatorListCell.self, forCellReuseIdentifier: CreatorListCell.reuseIdentifier)
    }
    
    // Properties
    weak var coordinator: ExploreCoordinator?
    private let viewModel: ExploreSubscribeViewModel
    private let disposeBag = DisposeBag()
    
    // Initializer
    init(viewModel: ExploreSubscribeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// Configure UI
private extension ExploreSubscribeViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        view.addSubview(subscribeTableView)
    }
    
    func makeConstraints() {
        subscribeTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
