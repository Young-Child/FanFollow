//
//  FeedManageViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/25.
//

import UIKit
import RxSwift
import RxRelay

final class FeedManageViewController: UIViewController {
    // View Properties
    private var tableView = UITableView(frame: .zero, style: .plain).then { tableView in
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemGray6

    }
    private let refreshControl = UIRefreshControl()

    // Properties
    private let disposeBag = DisposeBag()
    private let viewModel: FeedManageViewModel
    private let likeButtonTap = PublishRelay<String>()
    private let lastCellDisplayed = BehaviorRelay(value: false)

    // Initializer
    init(viewModel: FeedManageViewModel) {
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
private extension FeedManageViewController {
    func binding() {
        let input = input()
        let output = viewModel.transform(input: input)
        bindTableView(output)
    }

    func input() -> FeedManageViewModel.Input {
        return FeedManageViewModel.Input(
            viewWillAppear: .empty(),
            refresh: .empty(),
            lastCellDisplayed: .empty(),
            likeButtonTap: .empty()
        )
    }

    func bindTableView(_ output: FeedManageViewModel.Output) {

    }
}

// Configure UI
private extension FeedManageViewController {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
        configureNavigationItem()
        configureTableView()
    }

    func configureHierarchy() {
        view.addSubview(tableView)
    }

    func configureConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureNavigationItem() {
        let image = UIImage.add
        let barButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction(handler: { _ in

            })
        )
        navigationItem.rightBarButtonItem = barButtonItem
    }

    func configureTableView() {
        tableView.refreshControl = refreshControl
    }
}
