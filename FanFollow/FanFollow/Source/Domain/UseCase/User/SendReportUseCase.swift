//
//  SendReportUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/30.
//

import Foundation

import RxSwift

protocol SendReportUseCase: AnyObject {
    func reportOrBlock(banID: String, reasonIndex: Int) -> Completable
}

// Sent Report About User
final class DefaultSendUserReportUseCase: SendReportUseCase {
    private let reportRepository: ReportRepository
    private let authRepository: AuthRepository

    init(reportRepository: ReportRepository, authRepository: AuthRepository) {
        self.reportRepository = reportRepository
        self.authRepository = authRepository
    }

    func reportOrBlock(banID: String, reasonIndex: Int) -> Completable {
        let reason = ReportReason.reasons(reportType: .user)[reasonIndex].reason
        
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.reportRepository.sendReport(
                    reporterID: userID,
                    banID: banID,
                    isContent: false,
                    reason: reason
                )
                .asObservable()
            }
            .asCompletable()
    }
}

// Sent Report About Content
final class DefaultSendContentReportUseCase: SendReportUseCase {
    private let blockContentRepository: BlockContentRepository
    private let reportRepository: ReportRepository
    private let authRepository: AuthRepository
    
    init(
        reportRepository: ReportRepository,
        blockContentRepository: BlockContentRepository,
        authRepository: AuthRepository
    ) {
        self.reportRepository = reportRepository
        self.blockContentRepository = blockContentRepository
        self.authRepository = authRepository
    }
    
    private func report(banID: String) -> Completable {
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.blockContentRepository.blockPost(banID, to: userID)
                    .asObservable()
            }
            .asCompletable()
    }
    
    private func block(banID: String, reasonIndex: Int) -> Completable {
        let reason = ReportReason.reasons(reportType: .user)[reasonIndex].reason
        
        return authRepository.storedSession()
            .flatMap { storedSession in
                let userID = storedSession.userID
                return self.reportRepository.sendReport(
                    reporterID: userID,
                    banID: banID,
                    isContent: true,
                    reason: reason
                )
                .asObservable()
            }
            .asCompletable()
    }
    
    func reportOrBlock(banID: String, reasonIndex: Int) -> Completable {
        if reasonIndex == 0 {
            return report(banID: banID)
        }
        
        return Completable.concat(
            report(banID: banID),
            block(banID: banID, reasonIndex: reasonIndex)
        )
    }
}
