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
        $0.setTitleColor(.white, for: .normal)
        $0.layer.backgroundColor = UIColor(named: "AccentColor")?.cgColor
        $0.layer.cornerRadius = 8
        $0.setTitle("링크 추가하기", for: .normal)
    }
    
    private let links = BehaviorRelay<[String?]>(value: [nil])

    var updatedLinks: Observable<[String]> {
        get {
            return links.map { $0.compactMap { $0 } }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
                let backgroundColor = $0 ? UIColor.systemGray4.cgColor : UIColor(named: "AccentColor")?.cgColor
                self.nextButtonEnable.accept($0 == false)
                self.linkAddButton.layer.backgroundColor = backgroundColor
            }
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
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFrame = CGRect(x: .zero, y: .zero, width: self.view.frame.width, height: 64)
        let footerView = UIView(frame: viewFrame)
        linkAddButton.frame = CGRect(x: 16, y: 16, width: tableView.frame.size.width - 32, height: 32)
        footerView.addSubview(linkAddButton)
        
        return footerView
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

    func updateLink(index: Int, link: String?) {
        var updated = links.value
        updated[index] = link
        links.accept(updated)
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