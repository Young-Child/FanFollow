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
    private let navigationBar = FFNavigationBar()

    private var tableView = UITableView(frame: .zero, style: .plain).then { tableView in
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = Constants.Color.background
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
    }

    private let refreshControl = UIRefreshControl()

    private let feedResultLabel = UILabel().then {
        $0.textColor = .label
        $0.textAlignment = .center
        $0.text = Constants.Text.noProfileFeedResult
    }

    // Properties
    typealias DataSource = RxTableViewSectionedReloadDataSource<ProfileFeedSectionModel>
    
    weak var settingDelegate: SettingTabBarDelegate?
    weak var coordinator: ProfileFeedCoordinator?

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
    
    func postCell(_ cell: PostCell, didTapDeclarationButton post: Post) {
        coordinator?.presentDeclaration(post.postID)
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
        bindNavigationBar()
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
    
    func bindNavigationBar() {
        navigationBar.leftBarButton.rx.tap
            .bind(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    func bindTableView(_ output: ProfileFeedViewModel.Output) {
        let dataSource = generateDataSource()
        
        output.profileFeedSections
            .asDriver(onErrorJustReturn: [])
            .do { [weak self] value in
                guard let self else { return }
                self.refreshControl.endRefreshing()
                self.lastCellDisplayed.accept(false)

                if case .posts(let items) = value[1] {
                    self.feedResultLabel.isHidden = items.isEmpty == false
                    self.tableView.isScrollEnabled = items.isEmpty == false
                }
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
                self.navigationBar.titleView.text = item.creator.nickName
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
        configureNavigationItem()
        configureHierarchy()
        configureTableView()
    }

    func configureHierarchy() {
        switch viewType {
        case .feedManage:
            [tableView].forEach(view.addSubview(_:))
            configureFeedManageConstraints()
        case .profileFeed:
            [navigationBar, tableView].forEach(view.addSubview(_:))
            configureProfileFeedConstraints()
        }
        tableView.backgroundView = feedResultLabel
    }
    
    func configureFeedManageConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }

    func configureProfileFeedConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
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
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func configureTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.refreshControl = refreshControl
    }
}

extension ProfileFeedViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
