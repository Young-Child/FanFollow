//
//  FeedManageViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/25.
//

import UIKit
import RxSwift
import RxRelay
import RxDataSources

final class FeedManageViewController: UIViewController {
    // View Properties
    private var tableView = UITableView(frame: .zero, style: .plain).then { tableView in
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemGray6
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(CreatorInformationCell.self, forCellReuseIdentifier: "CreatorInformationCell")
    }
    private let refreshControl = UIRefreshControl()

    // Properties
    private let disposeBag = DisposeBag()
    private let viewModel: FeedManageViewModel
    private let likeButtonTap = PublishRelay<String>()
    private let lastCellDisplayed = BehaviorRelay(value: false)
    private var dataSource: RxTableViewSectionedReloadDataSource<FeedManageSectionModel>!

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
        configureDataSource()
        binding()
    }

    private func configureDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<FeedManageSectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch dataSource[indexPath.section] {
                case .creatorInformation(let items):
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "CreatorInformationCell", for: indexPath
                    ) as? CreatorInformationCell else { return UITableViewCell() }
                    let item = items[indexPath.row]
                    let creator = item.creator
                    let followerCount = item.followerCount
                    cell.configure(with: creator, followerCount: followerCount)
                    return cell
                case .posts(let items):
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "PostCell", for: indexPath
                    ) as? PostCell else { return UITableViewCell() }
                    let item = items[indexPath.row]
                    cell.configure(with: item, delegate: self, creatorViewIsHidden: true)
                    return cell
                }
            }
        )
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
        let lastCellDisplayed = tableView.rx.didScroll
            .withUnretained(self)
            .flatMap({ _, _ -> Observable<Void> in
                guard self.lastCellDisplayed.value == false else { return .empty() }
                let offsetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                let frameHeight = self.tableView.frame.size.height
                let lastCellDisplayed = offsetY > (contentHeight - frameHeight)
                self.lastCellDisplayed.accept(lastCellDisplayed)
                return lastCellDisplayed ? .just(()) : .empty()
            })

        return FeedManageViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable(),
            refresh: refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            lastCellDisplayed: lastCellDisplayed,
            likeButtonTap: likeButtonTap.asObservable()
        )
    }

    func bindTableView(_ output: FeedManageViewModel.Output) {
        output.feedManageSections
            .asDriver(onErrorJustReturn: [])
            .do { [weak self] _ in
                guard let self else { return }
                self.refreshControl.endRefreshing()
                self.lastCellDisplayed.accept(false)
            }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
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
        let barButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction(handler: { _ in

            })
        )
        navigationItem.rightBarButtonItem = barButtonItem
    }

    func configureTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.refreshControl = refreshControl
    }
}

// PostCellDelegate
extension FeedManageViewController: PostCellDelegate {
    func performTableViewBathUpdates(_ updates: (() -> Void)?) {
        tableView.performBatchUpdates(updates)
    }

    func likeButtonTap(postID: String) {
        likeButtonTap.accept(postID)
    }
}
