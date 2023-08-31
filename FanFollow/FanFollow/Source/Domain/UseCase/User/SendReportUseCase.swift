//
//  SendReportUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/30.
//

import RxSwift

protocol SendReportUseCase {
    func sendReport(banPostID: String, isContent: Bool, reason: String) -> Completable
}

final class DefaultSendReportUseCase: SendReportUseCase {
    private let reportRepository: ReportRepository
    private let authRepository: AuthRepository

    init(reportRepository: ReportRepository, authRepository: AuthRepository) {
        self.reportRepository = reportRepository
        self.authRepository = authRepository
    }

    func sendReport(banPostID: String, isContent: Bool, reason: String) -> Completable {
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.reportRepository.sendReport(
                    reporterID: userID,
                    banPostID: banPostID,
                    isContent: isContent,
                    reason: reason
                )
                .asObservable()
            }
            .asCompletable()
    }
}
