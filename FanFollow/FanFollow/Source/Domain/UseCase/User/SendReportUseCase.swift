//
//  SendReportUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/30.
//

import RxSwift

protocol SendReportUseCase {
    func sendPostReport(banPostID: String, reason: String) -> Completable
    func sendUserReport(banUserID: String, reason: String) -> Completable
}

final class DefaultSendReportUseCase: SendReportUseCase {
    private let reportRepository: ReportRepository
    private let authRepository: AuthRepository

    init(reportRepository: ReportRepository, authRepository: AuthRepository) {
        self.reportRepository = reportRepository
        self.authRepository = authRepository
    }

    func sendPostReport(banPostID: String, reason: String) -> Completable {
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.reportRepository.sendPostReport(
                    reporterID: userID,
                    banPostID: banPostID,
                    reason: reason
                )
                .asObservable()
            }
            .asCompletable()
    }

    func sendUserReport(banUserID: String, reason: String) -> Completable {
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.reportRepository.sendUserReport(
                    reporterID: userID,
                    banUserID: banUserID,
                    reason: reason
                )
                .asObservable()
            }
            .asCompletable()
    }
}
