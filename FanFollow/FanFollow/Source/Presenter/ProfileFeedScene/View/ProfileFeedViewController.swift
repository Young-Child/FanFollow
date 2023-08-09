//
//  ProfileFeedViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/28.
//

import UIKit

import RxDataSources
import RxRelay
import RxSwift

final class ProfileFeedViewController: UIViewController {
    // View Properties
    private var tableView = UITableView(frame: .zero, style: .plain).then { tableView in
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemGray6
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
    }
    private let refreshControl = UIRefreshControl()

    // Properties
    typealias DataSource = RxTableViewSectionedReloadDataSource<ProfileFeedSectionModel>
    
    weak var settingDelegate: SettingTabBarDelegate?

    private let disposeBag = DisposeBag()
    private let viewModel: ProfileFeedViewModel
    private let likeButtonTapped = PublishRelay<String>()
    private let followButtonTapped = PublishRelay<Void>()
    private let lastCellDisplayed = BehaviorRelay(value: true)
    private let didTapPostDeleteButton = PublishRelay<Post>()
    private let viewType: ViewType

    // Initializer
    init(viewModel: ProfileFeedViewModel, viewType: ViewType) {
        self.viewModel = viewModel
        self.viewType = viewType
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
    
<<<<<<< HEAD
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationItem()
        super.viewWillAppear(animated)
=======
    private func configureDataSource() {
        dataSource = DataSource(configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath.section] {
            case .profile(let items):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ProfileCell", for: indexPath
                ) as? ProfileCell else { return UITableViewCell() }

                let item = items[indexPath.row]
                let creator = item.creator
                let followerCount = item.followerCount
                let isFollow = item.isFollow
                let followButtonIsHidden: Bool
                switch self.viewType {
                case .feedManage:
                    followButtonIsHidden = true
                case .profileFeed:
                    followButtonIsHidden = false
                }

                cell.configure(
                    with: creator,
                    followerCount: followerCount,
                    isFollow: isFollow,
                    delegate: self,
                    followButtonIsHidden: followButtonIsHidden
                )
                return cell
            case .posts(let items):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "PostCell", for: indexPath
                ) as? PostCell else { return UITableViewCell() }

                let item = items[indexPath.row]

                cell.configure(with: item, delegate: self, creatorViewIsHidden: true)
                return cell
            }
        })
>>>>>>> develop
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
    
    func postCell(_ cell: PostCell, didTapEditButton post: Post) {
        self.settingDelegate?.settingController(self, didTapEdit: post)
    }
    
    func postCell(_ cell: PostCell, didTapDeleteButton post: Post) {
        self.didTapPostDeleteButton.accept(post)
    }
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
            followButtonTap: followButtonTapped.asObservable(),
            deletePost: didTapPostDeleteButton.asObservable()
        )
    }

    func bindTableView(_ output: ProfileFeedViewModel.Output) {
        let dataSource = generateDataSource()
        
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
    
    func generateDataSource() -> DataSource {
        return DataSource { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath.section] {
            case .profile(let items):
                let cell: ProfileCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                let item = items[indexPath.row]
                
                cell.delegate = self
                cell.configure(with: item, viewType: self.viewType)
                
                return cell
                
            case .posts(let items):
                let cell: PostCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

                let item = items[indexPath.row]
                cell.configure(with: item, couldEdit: self.viewType == .feedManage, delegate: self)
                return cell
            }
        }
    }
}

// Configure UI
private extension ProfileFeedViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureHierarchy()
        configureConstraints()
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
        let navigationBarIsHidden = (viewType == .feedManage)
        navigationController?.setNavigationBarHidden(navigationBarIsHidden, animated: false)
    }

    func configureTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.refreshControl = refreshControl
    }
}
