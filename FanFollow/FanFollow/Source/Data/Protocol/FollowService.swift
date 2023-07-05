//
//  FollowService.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/03.
//

import Foundation
import RxSwift

protocol FollowService: SupabaseService {
    func fetchFollowerList(followingID: String, startRange: Int, endRange: Int) -> Observable<[FollowDTO]>
    func fetchFollowingList(followerID: String, startRange: Int, endRange: Int) -> Observable<[FollowDTO]>
    func fetchFollowerCount(followingID: String) -> Observable<Int>
    func fetchFollowingCount(followerID: String) -> Observable<Int>
    func checkFollow(followingID: String, followerID: String) -> Observable<Bool>
    func insertFollow(followingID: String, followerID: String) -> Completable
    func deleteFollow(followingID: String, followerID: String) -> Completable
}
