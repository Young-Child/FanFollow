//
//  ReportRepository.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/30.
//

import Foundation

import RxSwift

protocol ReportRepository: SupabaseEndPoint {
    func sendPostReport(reporterID: String, banPostID: String, reason: String) -> Completable
    func sendUserReport(reporterID: String, banUserID: String, reason: String) -> Completable
}
