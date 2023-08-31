//
//  MailCoordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import MessageUI

final class MailCoordinator: NSObject, Coordinator {
    enum MailType {
        case bugReport
        
        var contentsFormat: String {
            switch self {
            case .bugReport:
                return Constants.Text.bugReportMailFormat
            }
        }
        
        var title: String {
            switch self {
            case .bugReport:
                return Constants.Text.bugReportMailTitle
            }
        }
    }
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let mailType: MailType
    
    init(navigationController: UINavigationController, mailType: MailType) {
        self.navigationController = navigationController
        self.mailType = mailType
    }
    
    func start() {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = self
        
        let body = generateMailContents(mailType)
        
        controller.setToRecipients(Constants.Text.developerEmails)
        controller.setSubject(mailType.title)
        controller.setMessageBody(body, isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            navigationController.present(controller, animated: true)
        } else {
            let controller = UIAlertController(
                title: Constants.Text.mailErrorAlertTitle,
                message: Constants.Text.mailErrorAlertMessage,
                preferredStyle: .alert
            )
            let action = UIAlertAction(title: Constants.Text.confirm, style: .default)
            controller.addAction(action)
            navigationController.present(controller, animated: true)
        }
    }
}

extension MailCoordinator: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        parentCoordinator?.removeChild(to: self)
        controller.dismiss(animated: true)
    }
}

private extension MailCoordinator {
    func generateMailContents(_ mailType: MailType) -> String {
        switch mailType {
        case .bugReport:
            let bundle = Bundle.main, key = "CFBundleShortVersionString"
            guard let appVersion = bundle.infoDictionary?[key] as? String else {
                return ""
            }
            
            let deviceOS = UIDevice.current.systemVersion
            
            return String(format: mailType.contentsFormat, deviceOS, appVersion)
        }
    }
}
