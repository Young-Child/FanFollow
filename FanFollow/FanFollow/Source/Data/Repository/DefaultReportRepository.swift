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

    func sendReport(reporterID: String, banPostID: String, isContent: Bool, reason: String) -> Completable {
        let request = ReportRequestDirector(builder: builder)
            .requestUpsertReport(
                reporterID: reporterID,
                banID: banPostID,
                isContent: isContent,
                reason: reason
            )

        return networkService.execute(request)
    }
}
