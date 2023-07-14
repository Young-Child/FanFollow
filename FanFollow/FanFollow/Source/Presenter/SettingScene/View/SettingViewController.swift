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
    private let settingTableView = UITableView().then {
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
    private let settingSections = SettingSectionModel.defaultModel
    private var dataSource = SettingViewController.dataSource()
    private let disposeBag = DisposeBag()
    
    // Initializer
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        configureUI()
        
        Observable.just(settingSections)
            .bind(to: settingTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        settingTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == .zero { return nil }
        
        guard let cell = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SettingSectionHeaderView.reuseIdentifier
        ) as? SettingSectionHeaderView else {
            return nil
        }
        
        let header = dataSource[section].identity
        cell.configureTitle(to: header)
        
        let backgroundView = UIView(frame: cell.bounds)
        backgroundView.backgroundColor = .white
        cell.backgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == .zero { return .zero }
        return 40
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
