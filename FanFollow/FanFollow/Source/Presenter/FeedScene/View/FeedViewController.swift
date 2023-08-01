//
//  FeedViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/17.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources

final class FeedViewController: UIViewController {
    // View Properties
    private var tableView = UITableView(frame: .zero, style: .plain).then { tableView in
        tableView.layoutMargins.top = 80
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemBackground
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
    }
    private let refreshControl = UIRefreshControl().then {
        $0.tintColor = UIColor(named: "AccentColor")
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
            }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension FeedViewController {
    func configureDataSource() -> RxTableViewSectionedReloadDataSource<PostSectionModel> {
        return RxTableViewSectionedReloadDataSource { dataSource, tableView, indexPath, model in
            let cell: PostCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: model, delegate: self)
            return cell
        }
    }
}

// PostCellDelegate
extension FeedViewController: PostCellDelegate {
    func postCell(expandLabel updates: (() -> Void)?) {
        tableView.performBatchUpdates(updates)
    }
    
    func postCell(_ cell: PostCell, didTappedLikeButton postID: String) {
        likeButtonTap.accept(postID)
    }
    
    func likeButtonTap(postID: String) {
        likeButtonTap.accept(postID)
    }
    
    func creatorNickNameLabelTap(creatorID: String) {
        // TODO: userID 입력 필요
        let userID = "a0728b90-0172-4552-9b31-1f3cab84900b"
        coordinator?.presentProfileViewController(creatorID: creatorID, userID: userID)
    }
}

// Configure UI
private extension FeedViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
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
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureNavigationItem() {
        let image = UIImage(named: "iconImage")?.withRenderingMode(.alwaysOriginal)

        let scrollToTopAction = UIAction { _ in
            let firstIndexPath = IndexPath(row: .zero, section: .zero)
            self.tableView.scrollToRow(at: firstIndexPath, at: .top, animated: true)
        }

        let barButtonItem = UIBarButtonItem(
            image: image,
            primaryAction: scrollToTopAction
        )
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = barButtonItem
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func configureTableView() {
        tableView.refreshControl = refreshControl
    }
}
