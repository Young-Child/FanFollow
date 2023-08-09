//
//  CreatorLinksTableViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/03.
//

import UIKit

import Then
import RxRelay
import RxSwift

final class CreatorLinksTableViewController: CreatorApplicationChildController {
    private let tableView = UITableView().then { tableView in
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(
            CreatorApplicationLinkCell.self,
            forCellReuseIdentifier: CreatorApplicationLinkCell.reuseIdentifier
        )
    }
    
    private let linkAddButton = UIButton().then {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 32)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfiguration)
        $0.layer.backgroundColor = UIColor.clear.cgColor
        $0.setImage(image, for: .normal)
    }
    
    private let links = BehaviorRelay<[String?]>(value: [nil])
    
    var writtenLinks: Observable<[String]> {
        get {
            links.compactMap { $0.compactMap { $0 } }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind()
    }
    
    private func bind() {
        linkAddButton.rx.tap
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: appendNewItem)
            .disposed(by: disposeBag)
        
        links
            .map { $0.filter { $0?.isEmpty ?? true || $0 == nil }.count > .zero }
            .asDriver(onErrorJustReturn: false)
            .drive {
                self.nextButtonEnable.accept($0 == false)
            }
            .disposed(by: disposeBag)
        
        Observable.merge([
            Notification.keyboardWillShow(),
            Notification.keyboardWillHide()
        ])
        .asDriver(onErrorJustReturn: .zero)
        .drive(onNext: {
            self.tableView.contentInset.bottom = $0
        })
        .disposed(by: disposeBag)
    }
}

// MARK: - Table view data source
extension CreatorLinksTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.value.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: CreatorApplicationLinkCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let index = indexPath.row, text = links.value[index]
        
        cell.configure(index: index, link: text)
        cell.delegate = self
        
        return cell
    }
}

// TableView Delegate Method
extension CreatorLinksTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 0
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        if indexPath.row == .zero { return nil }
        
        let deleteAction = generateSwipeAction(with: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// CreatorApplicationLinkCell Delegate Method
extension CreatorLinksTableViewController: CreatorApplicationLinkCellDelegate {
    func creatorApplicationTextFieldCell(
        _ cell: CreatorApplicationLinkCell,
        didChangeText changedText: (index: Int, text: String?)
    ) {
        var updated = links.value
        updated[changedText.index] = changedText.text ?? ""
        links.accept(updated)
    }
}

// Properties Update Method
private extension CreatorLinksTableViewController {
    func appendNewItem() {
        let itemCount = links.value.filter { $0?.isEmpty == false }.count
        
        if itemCount == links.value.count {
            var newItems = links.value
            newItems.append(nil)
            links.accept(newItems)
            tableView.reloadData()
        }
    }
    
    func removeItem(indexPath: IndexPath) {
        var newItem = links.value
        newItem.remove(at: indexPath.row)
        links.accept(newItem)
        
        tableView.performBatchUpdates {
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            newItem.enumerated().forEach { index, item in
                tableView.reloadRows(at: [IndexPath(row: index, section: .zero)], with: .fade)
            }
        }
    }

    func updateLink(index: Int, link: String?) {
        var updated = links.value
        updated[index] = link
        links.accept(updated)
    }
}

private extension CreatorLinksTableViewController {
    func configureUI() {
        configureTableView()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = generateFooterView()
    }
    
    func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func generateSwipeAction(with indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .normal, title: "") { action, view, handler in
            view.backgroundColor = .clear
            self.removeItem(indexPath: indexPath)
            handler(true)
        }
        
        deleteAction.backgroundColor = UIColor.white
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
        deleteAction.image = UIImage(
            systemName: "minus.circle",
            withConfiguration: imageConfiguration
        )?.withTintColor(.red, renderingMode: .alwaysOriginal)
        
        return deleteAction
    }
    
    func generateFooterView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.addSubview(linkAddButton)
        
        view.frame = CGRect(
            origin: .zero,
            size: CGSize(width: UIView.noIntrinsicMetric, height: 80)
        )
        
        linkAddButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalTo(80)
        }
        return view
    }
}

// Constants
private extension CreatorLinksTableViewController {
    enum Constants {
        static let addLinkButtonTitle = NSAttributedString(
            string: "링크 추가하기",
            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        )
    }
}
