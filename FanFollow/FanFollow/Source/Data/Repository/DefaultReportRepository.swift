//
//  DefaultReportRepository.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/30.
//

import Foundation

import RxSwift

struct DefaultReportRepository: ReportRepository {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func sendPostReport(reporterID: String, banPostID: String, reason: String) -> Completable {
        let request = ReportRequestDirector(builder: builder)
            .requestUpsertReport(
                reporterID: reporterID,
                banID: banPostID,
                isContent: true,
                reason: reason
            )

        return networkService.execute(request)
    }

    func sendUserReport(reporterID: String, banUserID: String, reason: String) -> Completable {
        let request = ReportRequestDirector(builder: builder)
            .requestUpsertReport(
                reporterID: reporterID,
                banID: banUserID,
                isContent: false,
                reason: reason
            )

        return networkService.execute(request)
    }
}
