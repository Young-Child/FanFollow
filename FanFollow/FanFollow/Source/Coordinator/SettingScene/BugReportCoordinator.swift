//
//  BugReportCoordinator.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import MessageUI

final class BugReportCoordinator: NSObject, Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = self
        
        let body = generateMailContents()
        controller.setToRecipients(Constants.Text.developerEmails)
        controller.setSubject(Constants.Text.bugReportMailTitle)
        controller.setMessageBody(body, isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            navigationController.present(controller, animated: true)
        } else {
            let controller = UIAlertController(
                title: Constants.Text.bugReportErrorAlertTitle,
                message: Constants.Text.bugReportErrorAlertMessage,
                preferredStyle: .alert
            )
            let action = UIAlertAction(title: Constants.Text.confirm, style: .default)
            controller.addAction(action)
            navigationController.present(controller, animated: true)
        }
    }
}

extension BugReportCoordinator: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        parentCoordinator?.removeChild(to: self)
        controller.dismiss(animated: true)
    }
}


private extension BugReportCoordinator {
    func generateMailContents() -> String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return ""
        }

        let deviceOS = UIDevice.current.systemVersion

        return String(format: Constants.Text.bugReportMailFormat, deviceOS, appVersion)
    }
}
