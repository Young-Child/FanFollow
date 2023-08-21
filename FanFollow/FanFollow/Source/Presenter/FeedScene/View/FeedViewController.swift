//
//  FeedViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/17.
//

import UIKit

import RxCocoa
import RxDataSources
import RxRelay
import RxSwift

final class FeedViewController: UIViewController {
    // View Properties
    private let navigationBar = FFNavigationBar()

    private var tableView = UITableView(frame: .zero, style: .plain).then { tableView in
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = Constants.Color.background
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
    }

    private let refreshControl = UIRefreshControl().then {
        $0.tintColor = Constants.Color.blue
    }

    private let feedResultLabel = UILabel().then {
        $0.textColor = .label
        $0.textAlignment = .center
        $0.text = Constants.Text.noFeedResult
    }
    
    // Properties
    weak var coordinator: FeedCoordinator?
    private let disposeBag = DisposeBag()
    private let viewModel: FeedViewModel
    private let likeButtonTap = PublishRelay<String>()
    private let lastCellDisplayed = BehaviorRelay(value: false)
    
    // Initializer
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLeftBarButton()
        configureUI()
        binding()
    }
}

// Binding Method
private extension FeedViewController {
    func binding() {
        let input = input()
        let output = viewModel.transform(input: input)
        bindTableView(output)
    }
    
    func input() -> FeedViewModel.Input {
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
        
        return FeedViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable(),
            refresh: refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            lastCellDisplayed: lastCellDisplayed,
            likeButtonTap: likeButtonTap.asObservable()
        )
    }
    
    func bindTableView(_ output: FeedViewModel.Output) {
        let dataSource = configureDataSource()
        
        output.posts
            .asDriver(onErrorJustReturn: [])
            .do { [weak self] newPosts in
                guard let self else { return }
                self.refreshControl.endRefreshing()
                self.lastCellDisplayed.accept(false)
                self.feedResultLabel.isHidden = newPosts.first?.items.isEmpty == false
            }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// Configure Data Source
extension FeedViewController {
    func configureDataSource() -> RxTableViewSectionedReloadDataSource<PostSectionModel> {
        return RxTableViewSectionedReloadDataSource { dataSource, tableView, indexPath, model in
            let cell: PostCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: model, delegate: self)
            return cell
        }
    }
}

// Post Cell Delegate Method
extension FeedViewController: PostCellDelegate {
    func postCell(expandLabel updates: (() -> Void)?) {
        tableView.performBatchUpdates(updates)
    }
    
    func postCell(_ cell: PostCell, didTappedLikeButton postID: String) {
        likeButtonTap.accept(postID)
    }
    
    func postCell(didTapProfilePresentButton creatorID: String) {
        // TODO: userID 입력 필요
        let userID = "56f17fb1-e9d0-4974-bf0b-43aad6a2526f"
        coordinator?.presentProfileViewController(creatorID: creatorID, userID: userID)
    }
    
    func postCell(didTapLinkPresentButton link: URL) {
        coordinator?.presentLinkViewController(to: link)
    }
    
    func postCell(_ cell: PostCell, didTapDeclarationButton post: Post) {
        coordinator?.presentDeclaration(post.postID)
    }
    
    func postCell(_ cell: PostCell, didTapEditButton post: Post) { }
    func postCell(_ cell: PostCell, didTapDeleteButton post: Post) { }
}

// Configure NavigationBar Method
private extension FeedViewController {
    func configureLeftBarButton() {
        let action = UIAction { _ in
            let firstIndexPath = IndexPath(row: .zero, section: .zero)
            self.tableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
        }
        
        navigationBar.leftBarButton.addAction(action, for: .touchUpInside)
        navigationBar.leftBarButton.setImage(Constants.Image.logoImageSmall, for: .normal)
    }
}


// Configure UI
private extension FeedViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        tableView.refreshControl = refreshControl
        
        configureHierarchy()
        configureConstraints()
    }
    
    func configureHierarchy() {
        [navigationBar, tableView, feedResultLabel].forEach(view.addSubview(_:))
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

        feedResultLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

