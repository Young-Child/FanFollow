//
//  ProfileFeedViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/28.
//

import UIKit
import RxSwift
import RxRelay
import RxDataSources

final class ProfileFeedViewController: UIViewController {
    // View Properties
    private var tableView = UITableView(frame: .zero, style: .plain).then { tableView in
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemGray6
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
    }
    private let refreshControl = UIRefreshControl()

    // Properties
    typealias DataSource = RxTableViewSectionedReloadDataSource<ProfileFeedSectionModel>

    private let disposeBag = DisposeBag()
    private let viewModel: ProfileFeedViewModel
    private let likeButtonTapped = PublishRelay<String>()
    private let followButtonTapped = PublishRelay<Void>()
    private let lastCellDisplayed = BehaviorRelay(value: true)
    private let viewType: ViewType
    private var dataSource: DataSource!

    // Initializer
    init(viewModel: ProfileFeedViewModel, viewType: ViewType) {
        self.viewModel = viewModel
        self.viewType = viewType
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func configureDataSource() {
        dataSource = DataSource(configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath.section] {
            case .profile(let items):
                let cell: ProfileCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                let item = items[indexPath.row]
                let profile = Profile(creator: item.creator, followersCount: item.followerCount)
                
                cell.delegate = self
                cell.configure(with: profile, viewType: self.viewType)
                
                return cell
            case .posts(let items):
                let cell: PostCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

                let item = items[indexPath.row]
                cell.configure(with: item, delegate: self)
                return cell
            }
        })
    }
}

// ProfileCellDelegate, PostCellDelegate
extension ProfileFeedViewController: PostCellDelegate {
    func postCell(_ cell: PostCell, didTappedLikeButton postID: String) {
        likeButtonTapped.accept(postID)
    }
    
    func postCell(expandLabel updates: (() -> Void)?) {
        tableView.performBatchUpdates(updates)
    }
    
    func postCell(didTapProfilePresentButton creatorID: String) {}
    func postCell(didTapLinkPresentButton link: URL) { }
}

extension ProfileFeedViewController: ProfileCellDelegate {
    func profileCell(cell: ProfileCell, expandLabel expandAction: (() -> Void)?) {
        tableView.performBatchUpdates(expandAction)

    }
    
    func profileCell(didTapFollowButton cell: ProfileCell) {
        followButtonTapped.accept(())
    }
}

extension ProfileFeedViewController {
    enum ViewType {
        case profileFeed
        case feedManage
    }
}

// Binding Method
private extension ProfileFeedViewController {
    func binding() {
        let input = input()
        let output = viewModel.transform(input: input)
        bindTableView(output)
    }

    func input() -> ProfileFeedViewModel.Input {
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

        return ProfileFeedViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable(),
            refresh: refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            lastCellDisplayed: lastCellDisplayed,
            likeButtonTap: likeButtonTapped.asObservable(),
            followButtonTap: followButtonTapped.asObservable()
        )
    }

    func bindTableView(_ output: ProfileFeedViewModel.Output) {
        output.profileFeedSections
            .asDriver(onErrorJustReturn: [])
            .do { [weak self] value in
                guard let self else { return }
                self.refreshControl.endRefreshing()
                self.lastCellDisplayed.accept(false)
            }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// Configure UI
private extension ProfileFeedViewController {
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
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }

    func configureNavigationItem() {
        switch viewType {
        case .profileFeed:
            navigationController?.setNavigationBarHidden(false, animated: true)
        case .feedManage:
            let barButtonItem = UIBarButtonItem(
                systemItem: .add,
                primaryAction: UIAction(handler: { _ in
                    // TODO: 게시글 작성 화면 작업 후 코드 작성
                })
            )
            navigationItem.rightBarButtonItem = barButtonItem
        }
    }

    func configureTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.refreshControl = refreshControl
    }
}
