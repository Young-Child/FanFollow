//
//  ReportViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/31.
//

import UIKit

final class ReportViewController: UIViewController {
    // View Properties
    private let titleLabel = UILabel().then {
        $0.font = .coreDreamFont(ofSize: 18, weight: .regular)
        $0.textColor = Constants.Color.label
    }
    
    private let noticeLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = Constants.Text.reportNoticeMessage
        $0.font = .coreDreamFont(ofSize: 14, weight: .regular)
        $0.textColor = Constants.Color.grayDark
    }
    
    private let reasonTableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.separatorColor = .lightGray
        $0.separatorInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        $0.register(
            ReportReasonTableViewCell.self,
            forCellReuseIdentifier: ReportReasonTableViewCell.reuseIdentifier
        )
    }
    
    // Properties
    private let reportType: ReportType
    
    // Initializer
    init(reportType: ReportType) {
        self.reportType = reportType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// TableView Delegate, DataSource
extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReportReason.reasons(reportType: reportType).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReportReasonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureCell(
            reason: ReportReason.reasons(reportType: reportType)[indexPath.row].reason
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(ReportReason.reasons(reportType: reportType)[indexPath.row].reason)
    }
}

// Configure UI
private extension ReportViewController {
    func configureUI() {
        configureTitle()
        configureTableView()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureTableView() {
        reasonTableView.dataSource = self
        reasonTableView.delegate = self
    }
    
    func configureTitle() {
        titleLabel.text = reportType.title + Constants.Text.reportTitle
    }
    
    func configureHierarchy() {
        [titleLabel, noticeLabel, reasonTableView].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Spacing.large)
            $0.leading.equalToSuperview().offset(Constants.Spacing.medium)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.medium)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        reasonTableView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().offset(-Constants.Spacing.medium)
        }
    }
}
