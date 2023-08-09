//
//  CreatorLinksTableViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/03.
//

import UIKit

import RxRelay
import RxSwift

final class CreatorLinksTableViewController: UITableViewController {
    private let links = BehaviorRelay<[String?]>(value: [nil])

    var updatedLinks: Observable<[String]> {
        return links.compactMap { $0.compactMap { $0 } }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(
            CreatorApplicationLinkCell.self,
            forCellReuseIdentifier: CreatorApplicationLinkCell.reuseIdentifier
        )
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.value.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: CreatorApplicationLinkCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let index = indexPath.row, text = links.value[index]
        
        cell.configure(index: index, link: text)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFrame = CGRect(x: .zero, y: .zero, width: self.view.frame.width, height: 64)
        let footerView = UIView(frame: viewFrame)
        
        let addLinkAction = UIAction {
            _ in self.appendLink()
        }
        
        let button = UIButton().then {
            $0.frame = CGRect(x: 16, y: 16, width: tableView.frame.size.width - 32, height: 32)
            $0.layer.backgroundColor = UIColor.systemGray5.cgColor
            $0.layer.cornerRadius = 8
            $0.setTitle("링크 추가하기", for: .normal)
        }
        
        button.addAction(addLinkAction, for: .touchUpInside)
        
        footerView.addSubview(button)
        
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

private extension CreatorLinksTableViewController {
    func appendLink() {
        var newItems = links.value
        let existNil = newItems.filter { $0 == nil }.count > .zero
        let existEmpty = newItems.compactMap { $0 }.filter { $0.isEmpty }.count > .zero
        
        if existNil || existEmpty { return }
        
        newItems.append(nil)
        links.accept(newItems)
        tableView.reloadData()
    }

    func updateLink(index: Int, link: String?) {
        var updated = links.value
        updated[index] = link
        links.accept(updated)
    }
}

private extension CreatorLinksTableViewController {
    enum Constants {
        static let addLinkButtonTitle = NSAttributedString(
            string: "링크 추가하기",
            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        )
    }
}
