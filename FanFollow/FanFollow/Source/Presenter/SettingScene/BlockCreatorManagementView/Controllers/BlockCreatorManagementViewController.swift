//
//  BlockCreatorManagementViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/31.
//

import UIKit

import RxSwift
import RxRelay
import RxDataSources

final class BlockCreatorManagementViewController: UIViewController {
    // View Properties
    private let navigationBar = FFNavigationBar()

    private let tableView = UITableView(frame: .zero, style: .plain).then { tableView in
        tableView.backgroundColor = Constants.Color.background
        tableView.register(
            BlockCreatorCell.self,
            forCellReuseIdentifier: BlockCreatorCell.reuseIdentifier
        )
    }

    private let resultLabel = UILabel().then { label in
        label.textColor = .label
        label.textAlignment = .center
        label.text = Constants.Text.noblockedCreatorResult
        label.isHidden = true
    }

    // Properties
    typealias DataSource = RxTableViewSectionedAnimatedDataSource<BlockCreatorSectionModel>

    weak var coordinator: BlockCreatorManagementCoordinator?

    private let disposeBag = DisposeBag()
    private let viewModel: BlockCreatorManagementViewModel
    private let blockToggleButtonTapped = PublishRelay<String>()

    // Initializer
    init(viewModel: BlockCreatorManagementViewModel) {
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

// BlockCreatorCellDelegate
extension BlockCreatorManagementViewController: BlockCreatorCellDelegate {
    func blockCreatorCell(didTapBlockToggleButton banID: String) {
        blockToggleButtonTapped.accept(banID)
    }
}

// Binding Method
private extension BlockCreatorManagementViewController {
    func binding() {
        let input = input()
        let output = viewModel.transform(input: input)
        bindTableView(output)
    }

    func input() -> BlockCreatorManagementViewModel.Input {
        return BlockCreatorManagementViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable(),
            blockToggleButtonTap: blockToggleButtonTapped.asObservable()
        )
    }

    func bindTableView(_ output: BlockCreatorManagementViewModel.Output) {
        let dataSource = generateDataSource()

        let blockCreators = output.blockCreators
            .asDriver(onErrorJustReturn: [])

        blockCreators
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        blockCreators
            .map {
                $0.first?.items.isEmpty == false
            }
            .drive(self.resultLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }

    func generateDataSource() -> DataSource {
        return DataSource { _, tableView, indexPath, item in
            let cell: BlockCreatorCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: item, delegate: self)
            return cell
        }
    }
}

// Configure UI
private extension BlockCreatorManagementViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        tableView.backgroundView = resultLabel
        configureHierarchy()
        configureConstraints()
        configureNavigationItem()
    }

    func configureHierarchy() {
        [navigationBar, tableView].forEach(view.addSubview)
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
    }

    func configureNavigationItem() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 22)
        let backImage = Constants.Image.back?.withConfiguration(configuration)

        navigationBar.titleView.text = Constants.Text.blockedCreator
        navigationBar.titleView.textColor = Constants.Color.label

        navigationBar.leftBarButton.setImage(backImage, for: .normal)
        navigationBar.leftBarButton.addAction(
            UIAction(handler: { _ in self.coordinator?.close(to: self) }),
            for: .touchUpInside
        )
    }
}
