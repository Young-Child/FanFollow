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
    func insertFollow(followerID: String, followingID: String) -> Completable
    func deleteFollow(followerID: String, followingID: String) -> Completable
}
