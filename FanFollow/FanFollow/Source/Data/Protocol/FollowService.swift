//
//  FollowService.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/03.
//

import Foundation
import RxSwift

protocol FollowService {
    func fetchFollowerList(followingId: String, startRange: Int, endRange: Int) -> Observable<[FollowDTO]>
    func fetchFollowingList(followerId: String, startRange: Int, endRange: Int) -> Observable<[FollowDTO]>
    func fetchFollowerCount(followingId: String) -> Observable<Int>
    func fetchFollowingCount(followerId: String) -> Observable<Int>
    func checkFollow(followingId: String, followerId: String) -> Observable<Bool>
    func insertFollow(followerId: String, followingId: String) -> Completable
    func deleteFollow(followerId: String, followingId: String) -> Completable
}
