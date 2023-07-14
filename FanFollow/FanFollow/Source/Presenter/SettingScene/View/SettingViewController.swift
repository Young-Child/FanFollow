//
//  SettingViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift
import RxDataSources
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
        
        $0.separatorColor = .clear
        $0.backgroundColor = .clear
    }
    
    // Properties
    private var dataSource = SettingViewController.dataSource()
    private let viewModel: SettingViewModel
    private let disposeBag = DisposeBag()
    
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
    
    func binding() {
        let viewWillAppearEvent = rx.methodInvoked(#selector(viewWillAppear))
            .map { _ in }.asObservable()
        
        settingTableView.rx.itemSelected
            .asObservable()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        let input = SettingViewModel.Input(viewWillAppear: viewWillAppearEvent)
        
        let output = viewModel.transform(input: input)
        
        output.settingSections
            .bind(to: settingTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        settingTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == .zero { return nil }
        
        let cell: SettingSectionHeaderView = tableView.dequeueReusableHeaderView()
        
        let header = dataSource[section].identity
        cell.configureTitle(to: header)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == .zero { return .zero }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pushExampleViewController()
    }
}

private extension SettingViewController {
    func pushExampleViewController() {
        let exampleViewController = UIViewController()
        exampleViewController.view.backgroundColor = .red
        navigationController?.pushViewController(exampleViewController, animated: true)
    }
}

// RxDataSource Method
private extension SettingViewController {
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<SettingSectionModel> {
        return RxTableViewSectionedAnimatedDataSource(
            configureCell: { dataSource, tableView, indexPath, model in
                switch dataSource[indexPath] {
                case let .profile(imageName, nickName):
                    let cell: ProfileThumbnailCell = tableView.dequeueReusableCell(
                        forIndexPath: indexPath
                    )
                    let profileImage = UIImage(named: imageName)
                    cell.configureCell(nickName: nickName, image: profileImage)
                    return cell
                case let .base(title):
                    let cell: SettingBaseCell = tableView.dequeueReusableCell(
                        forIndexPath: indexPath
                    )
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
