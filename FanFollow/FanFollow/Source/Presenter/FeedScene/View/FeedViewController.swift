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

    private var tableView = UITableView(frame: .zero, style: .plain).then { tableView in
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemBackground
        tableView.register(PostCell.self, forCellReuseIdentifier: "Cell")
    }
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    private let viewModel = FeedViewModel(fetchFeedUseCase: DefaultFetchFeedUseCase(postRepository: DefaultPostRepository(networkService: DefaultNetworkService())), changeLikeUseCase: DefaultChangeLikeUseCase(likeRepository: DefaultLikeRepository(networkService: DefaultNetworkService())), followerID: "5b587434-438c-49d8-ae3c-88bb27a891d4")
    private let reachedBottom = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.refreshControl = refreshControl
        tableView.delegate = self

        let lastCellDisplayed = tableView.rx.contentOffset
            .map { [weak self] offset in
                guard let self else { return false }
                return offset.y + self.tableView.frame.size.height > self.tableView.contentSize.height
            }

        let input = FeedViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable(),
            refresh: refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            lastCellDisplayed: lastCellDisplayed,
            likeButtonTap: Observable.just("")
        )

        let output = viewModel.transform(input: input)
        output.posts.observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: PostCell.self)) { _, post, cell in
                cell.configure(with: post)
            }
            .disposed(by: disposeBag)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

/*
final class FeedViewController: UIViewController {

    private var collectionView: UICollectionView?
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    private let viewModel = FeedViewModel(fetchFeedUseCase: DefaultFetchFeedUseCase(postRepository: DefaultPostRepository(networkService: DefaultNetworkService())), changeLikeUseCase: DefaultChangeLikeUseCase(likeRepository: DefaultLikeRepository(networkService: DefaultNetworkService())), followerID: "5b587434-438c-49d8-ae3c-88bb27a891d4")
    private let reachedBottom = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(600))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(600))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        let collectionView = UICollectionView(
            frame: view.bounds, collectionViewLayout: layout
        ).then { collectionView in
            collectionView.refreshControl = refreshControl
            collectionView.backgroundColor = .systemBackground
            collectionView.register(PostCell.self, forCellWithReuseIdentifier: "Cell")
        }
        view.addSubview(collectionView)
        self.collectionView = collectionView

        let input = FeedViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable(),
            refresh: refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            lastCellDisplayed: Observable.just(()),
            likeButtonTap: Observable.just("")
        )

        let output = viewModel.transform(input: input)
        output.posts
            .do(onNext: { [weak self] _ in
                guard let self else { return }
                self.refreshControl.endRefreshing()
            })
            .drive(collectionView.rx.items(cellIdentifier: "Cell", cellType: PostCell.self)) { index, post, cell in
                cell.configure(with: post)
            }
            .disposed(by: disposeBag)
    }
}
*/
