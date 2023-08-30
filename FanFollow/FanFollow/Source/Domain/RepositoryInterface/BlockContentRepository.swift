//
//  BlockContentRepository.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/30.
//

import Foundation
import RxSwift

protocol BlockContentRepository: SupabaseEndPoint {
    func blockPost(_ postID: String, to userID: String) -> Completable
}
