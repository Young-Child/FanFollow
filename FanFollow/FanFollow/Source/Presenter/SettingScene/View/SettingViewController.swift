//
//  SettingViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import RxSwift
import RxDataSources
import Then

final class SettingViewController: TopTabBarController {
    // View Properties
    private let settingTableView = UITableView().then {
        $0.register(
            ProfileThumbnailCell.self,
            forCellReuseIdentifier: ProfileThumbnailCell.reuseIdentifier
        )
    }
    
    // Properties
    private let settingSections = SettingSectionModel.defaultModel
    private let disposeBag = DisposeBag()
    
    // Initializer
    convenience init() {
        self.init(tabBar: SettingTabBar())
        configureUI()
        
        let dataSource = Self.dataSource()
        Observable.just(settingSections)
            .bind(to: settingTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
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
                default:
                    return UITableViewCell()
                }
            },
            titleForHeaderInSection: { dataSource, index in
                let section = dataSource[index]
                return section.identity
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
