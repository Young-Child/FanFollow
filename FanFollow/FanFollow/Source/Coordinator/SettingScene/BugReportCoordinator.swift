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
        
        let body = Constants.generateMailContents()
        controller.setToRecipients(["dlrudals8899@gmail.com"])
        controller.setSubject("<팬팔> 문의 및 버그 제보하기")
        controller.setMessageBody(body, isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            navigationController.present(controller, animated: true)
        } else {
            let controller = UIAlertController(
                title: "메일 앱 에러",
                message: "메일 앱을 설정해주세요.",
                preferredStyle: .alert
            )
            let action = UIAlertAction(title: "확인", style: .default)
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
    enum Constants {
        static let bodyString = """
                                서비스를 이용하시는데 불편을 드려서 죄송합니다.
                                발생하신 버그에 대해서 이곳에 작성해주세요.
                                ---------------
                                
                                Device OS: %@
                                App Version: %@
                                
                                ---------------
                                """
        
        static func generateMailContents() -> String {
            guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                return ""
            }
            
            let deviceOS = UIDevice.current.systemVersion
            
            return String(format: bodyString, deviceOS, appVersion)
        }
    }
}
