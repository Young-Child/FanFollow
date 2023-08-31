//
//  BlockCreatorManagementViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/31.
//

import UIKit

import RxSwift
import RxRelay
import RxDataSources

final class BlockCreatorManagementViewController: UIViewController {
    // View Properties
    private let navigationBar = FFNavigationBar()

    private let tableView = UITableView(frame: .zero, style: .plain).then { tableView in
        tableView.backgroundColor = Constants.Color.background
    }

    private let resultLabel = UILabel().then { label in
        label.textColor = .label
        label.textAlignment = .center
        label.text = Constants.Text.noProfileFeedResult
    }

    // Properties
    typealias DataSource = RxTableViewSectionedAnimatedDataSource<BlockCreatorSectionModel>

    weak var coordinator: BlockCreatorManagementCoordinator?
    private let viewModel: BlockCreatorManagementViewModel
    private let blockToggleButtonTapped = PublishRelay<String>()

    // Initializer
    init(viewModel: BlockCreatorManagementViewModel) {
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
        binding()
    }
}

// Binding Method
private extension BlockCreatorManagementViewController {
    func binding() {

    }
}

// Configure UI
private extension BlockCreatorManagementViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureHierarchy()
        configureConstraints()
        configureNavigationItem()
    }

    func configureHierarchy() {
        [navigationBar, tableView].forEach(view.addSubview)
    }

    func configureConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.Spacing.xLarge)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configureNavigationItem() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 22)
        let backImage = Constants.Image.back?.withConfiguration(configuration)

        navigationBar.leftBarButton.setImage(backImage, for: .normal)
        navigationBar.leftBarButton.addAction(
            UIAction(handler: { _ in self.coordinator?.close(to: self) }),
            for: .touchUpInside
        )
    }
}
