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
    private let links = BehaviorRelay(value: [""])

    var updatedLinks: Observable<[String]> {
        return links.asObservable()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(CreatorApplicationTextFieldCell.self, forCellReuseIdentifier: "LinkCell")
        tableView.register(ButtonCell.self, forCellReuseIdentifier: "ButtonCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return links.value.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
            guard let cell = cell as? CreatorApplicationTextFieldCell else { return cell }
            let title = "링크\(indexPath.row + 1)"
            let text = links.value[indexPath.row]
            cell.configure(
                title: title,
                text: text,
                keyboardType: .URL,
                onTextChanged: { [weak self] updatedText in
                    guard let self else { return }
                    self.updateLink(index: indexPath.row, link: updatedText)
                }
            )
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
            guard let cell = cell as? ButtonCell else { return cell }
            cell.configure(
                attributedTitle: Constants.addLinkButtonTitle,
                backgroundColor: UIColor(named: "SecondaryColor"),
                onButtonTapped: { [weak self] in
                    guard let appendLink = self?.appendLink else { return }
                    appendLink()
                }
            )
            return cell
        }
    }
}

private extension CreatorLinksTableViewController {
    func appendLink() {
        let current = links.value
        let someLinksIsEmpty = current.filter { $0.isEmpty }.count > 0
        guard someLinksIsEmpty == false else { return }
        let new = current + [""]
        links.accept(new)
        tableView.reloadData()
    }

    func updateLink(index: Int, link: String?) {
        var updated = links.value
        updated[index] = link ?? ""
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
