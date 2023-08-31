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
        $0.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.textColor = Constants.Color.label
    }
    
    private let noticeLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = Constants.Text.reportNoticeMessage
        $0.font = .coreDreamFont(ofSize: 16, weight: .regular)
        $0.textColor = Constants.Color.label
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

// Configure UI
private extension ReportViewController {
    func configureUI() {
        configureTitle()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureTitle() {
        titleLabel.text = reportType.title + Constants.Text.reportTitle
    }
    
    func configureHierarchy() {
        [titleLabel, noticeLabel].forEach(view.addSubview(_:))
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(Constants.Spacing.medium)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.medium)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.trailing.equalTo(titleLabel)
        }
    }
}
