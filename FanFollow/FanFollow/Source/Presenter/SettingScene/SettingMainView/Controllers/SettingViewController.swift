//
//  SettingViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxDataSources
import RxSwift
import Then

final class SettingViewController: UIViewController {
    // View Properties
    private let settingTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(
            ProfileThumbnailCell.self,
            forCellReuseIdentifier: ProfileThumbnailCell.reuseIdentifier
        )
        $0.register(SettingBaseCell.self, forCellReuseIdentifier: SettingBaseCell.reuseIdentifier)
        $0.register(
            SettingSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: SettingSectionHeaderView.reuseIdentifier
        )
        
        $0.separatorColor = Constants.Color.clear
        $0.backgroundColor = Constants.Color.clear
    }
    
    // Properties
    private var dataSource = SettingViewController.dataSource()
    private let viewModel: SettingViewModel
    private let disposeBag = DisposeBag()
    
    weak var settingTabBarDelegate: SettingTabBarDelegate?
    
    // Initializer
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        binding()
    }
}

// Binding Method
private extension SettingViewController {
    func binding() {
        let output = bindingInput()
        
        bindTableView(output)
        bindCreatorState(output)
    }
    
    func bindCreatorState(_ output: SettingViewModel.Output) {
        output.isCreator
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {
                self.settingTabBarDelegate?.settingController(
                    self,
                    removeFeedManageTab: $0
                )
            })
            .disposed(by: disposeBag)
    }
    
    func bindTableView(_ output: SettingViewModel.Output) {
        output.settingSections
            .asDriver(onErrorJustReturn: [])
            .drive(settingTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        settingTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.zip(
            settingTableView.rx.itemSelected,
            settingTableView.rx.modelSelected(SettingSectionItem.self)
        )
        .asDriver(
            onErrorJustReturn: (IndexPath(), SettingSectionItem.base(title: "", action: .profile))
        )
        .drive(onNext: { indexPath, item in
            self.settingTableView.deselectRow(at: indexPath, animated: true)
            self.settingTabBarDelegate?.settingController(self, didTapPresent: item)
        })
        .disposed(by: disposeBag)
    }
    
    func bindingInput() -> SettingViewModel.Output {
        let viewWillAppearEvent = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }.asObservable()
        
        let input = SettingViewModel.Input(viewWillAppear: viewWillAppearEvent)
        
        return viewModel.transform(input: input)
    }
}

// UITableViewDelegate method
extension SettingViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        if section == .zero { return nil }
        
        let cell: SettingSectionHeaderView = tableView.dequeueReusableHeaderView()
        
        let header = dataSource[section].identity
        cell.configureTitle(to: header)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        if section == .zero { return .zero }
        return 30
    }
}

// RxDataSource Method
private extension SettingViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<SettingSectionModel> {
        return RxTableViewSectionedReloadDataSource(
            configureCell: { dataSource, tableView, indexPath, _ in
                switch dataSource[indexPath] {
                case let .profile(nickName, userID, profileURL, _):
                    let cell: ProfileThumbnailCell = tableView.dequeueReusableCell(for: indexPath)
                    cell.configureCell(nickName: nickName, userID: userID, profileURL: profileURL)
                    return cell
                case let .base(title, _):
                    let cell: SettingBaseCell = tableView.dequeueReusableCell(for: indexPath)
                    cell.configureCell(to: title)
                    return cell
                }
            }
        )
    }
}

// Configure UI
private extension SettingViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [settingTableView].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        settingTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
