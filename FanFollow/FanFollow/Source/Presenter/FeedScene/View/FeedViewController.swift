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

final class FeedViewController: UIViewController {
    // View Properties
    private var tableView = UITableView(frame: .zero, style: .plain).then { tableView in
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemGray6
        tableView.register(PostCell.self, forCellReuseIdentifier: "Cell")
    }
    private let refreshControl = UIRefreshControl()

    // Properties
    private let disposeBag = DisposeBag()
    private let viewModel: FeedViewModel
    private let likeButtonTap = PublishRelay<String>()
    private let lastCellDisplayed = BehaviorRelay(value: false)
    private var tableViewLastContentOffset = CGFloat(0)

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
        output.posts
            .asDriver(onErrorJustReturn: [])
            .do { [weak self] newPosts in
                guard let self else { return }
                self.refreshControl.endRefreshing()
                self.lastCellDisplayed.accept(false)
            }
            .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: PostCell.self)) { _, post, cell in
                cell.configure(with: post, delegate: self)
            }
            .disposed(by: disposeBag)
    }
}

// UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollUp = tableViewLastContentOffset > scrollView.contentOffset.y
        let scrollDown = tableViewLastContentOffset < scrollView.contentOffset.y && tableViewLastContentOffset > 0
        if scrollUp {
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else if scrollDown {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        tableViewLastContentOffset = scrollView.contentOffset.y
    }
}

// PostCellDelegate
extension FeedViewController: PostCellDelegate {
    func performTableViewBathUpdates(_ updates: (() -> Void)?) {
        tableView.performBatchUpdates(updates)
    }

    func likeButtonTap(postID: String) {
        likeButtonTap.accept(postID)
    }
}

// Configure UI
private extension FeedViewController {
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
        let image = UIImage(named: "FeedTopAppImage")
        let barButtonItem = UIBarButtonItem(
            image: image,
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let self else { return }
                let contentOffset = CGPoint(x: 0, y: -self.tableView.safeAreaInsets.top)
                self.tableView.setContentOffset(contentOffset, animated: true)
            })
        )
        navigationItem.leftBarButtonItem = barButtonItem
    }

    func configureTableView() {
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableViewLastContentOffset = tableView.contentOffset.y
    }
}
