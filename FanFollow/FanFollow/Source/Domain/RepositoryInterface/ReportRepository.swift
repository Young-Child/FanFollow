//
//  ReportRepository.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/30.
//

import Foundation

import RxSwift

protocol ReportRepository: SupabaseEndPoint {
    func sendReport(
        reporterID: String,
        banID: String,
        isContent: Bool,
        reason: String
    ) -> Completable
}
