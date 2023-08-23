//
//  ExploreSubscribeViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/28.
//

import UIKit

import RxSwift

final class ExploreSubscribeViewController: UIViewController {
    // View Property
    private let subscribeTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(CreatorListCell.self, forCellReuseIdentifier: CreatorListCell.reuseIdentifier)
    }

    private let subscribeResultLabel = UILabel().then {
        $0.textColor = .label
        $0.textAlignment = .center
        $0.text = Constants.Text.noSubscribeResult
    }
    
    // Properties
    weak var coordinator: ExploreCoordinator?
    weak var delegate: ExploreSubscribeDelegate?
    private let viewModel: ExploreSubscribeViewModel
    private let disposeBag = DisposeBag()
    
    // Initializer
    init(viewModel: ExploreSubscribeViewModel) {
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

// Binding
extension ExploreSubscribeViewController {
    func binding() {
        let output = bindingInput()
        
        bindTableView(output)
    }
    
    func bindingInput() -> ExploreSubscribeViewModel.Output {
        let viewWillAppearEvent = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }
            .asObservable()
        
        let viewDidScrollEvent = subscribeTableView.rx.didScroll
            .flatMap { _ in
                let collectionViewContentSizeY = self.subscribeTableView.contentSize.height
                let contentOffsetY = self.subscribeTableView.contentOffset.y
                let heightRemainBottomHeight = collectionViewContentSizeY - contentOffsetY
                let frameHeight = self.subscribeTableView.frame.size.height
                let reachBottom = heightRemainBottomHeight < frameHeight
                
                return reachBottom ? Observable<Void>.just(()) : Observable<Void>.empty()
            }
            .skip(1)
            .asObservable()
        
        let input = ExploreSubscribeViewModel.Input(
            viewWillAppear: viewWillAppearEvent,
            viewDidScroll: viewDidScrollEvent
        )
        
        return viewModel.transform(input: input)
    }
    
    private func bindTableView(_ output: ExploreSubscribeViewModel.Output) {
        output.creatorListModel
            .asDriver(onErrorJustReturn: [])
            .do(onNext: { self.subscribeResultLabel.isHidden = $0.isEmpty == false })
            .drive(subscribeTableView.rx.items(
                cellIdentifier: CreatorListCell.reuseIdentifier,
                cellType: CreatorListCell.self)
            ) { _, data, cell in
                cell.configureCell(creator: data)
            }
            .disposed(by: disposeBag)
        
        subscribeTableView.rx.modelSelected(Creator.self)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { item in
                self.delegate?.exploreViewController(self, didTapPresent: item)
            }
            .disposed(by: disposeBag)
    }
}

// Configure UI
private extension ExploreSubscribeViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [subscribeTableView, subscribeResultLabel].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        subscribeTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        subscribeResultLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
