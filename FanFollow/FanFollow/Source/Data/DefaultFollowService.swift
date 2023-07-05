//
//  DefaultFollowService.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/03.
//

import Foundation
import RxSwift

struct DefaultFollowService: FollowService {
    private let networkManger: Network

    init(_ networkManger: Network = NetworkManager()) {
        self.networkManger = networkManger
    }

    func fetchFollowerList(followingID: String, startRange: Int, endRange: Int) -> Observable<[FollowDTO]> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowerList(followingID, startRange: startRange, endRange: endRange)

        return networkManger.data(request)
            .compactMap { try? JSONDecoder().decode([FollowDTO].self, from: $0) }
    }

    func fetchFollowingList(followerID: String, startRange: Int, endRange: Int) -> Observable<[FollowDTO]> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowingList(followerID, startRange: startRange, endRange: endRange)

        return networkManger.data(request)
            .compactMap { try? JSONDecoder().decode([FollowDTO].self, from: $0) }
    }

    func fetchFollowerCount(followingID: String) -> RxSwift.Observable<Int> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowCount(followingID: followingID)

        return networkManger.response(request)
            .map { contentCount($0.response) }
    }

    func fetchFollowingCount(followerID: String) -> RxSwift.Observable<Int> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowCount(followerID: followerID)

        return networkManger.response(request)
            .map { contentCount($0.response) }
    }

    func checkFollow(followingID: String, followerID: String) -> RxSwift.Observable<Bool> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowCount(followingID: followingID, followerID: followerID)

        return networkManger.response(request)
            .map { contentCount($0.response) > 0 ? true : false }
    }

    func insertFollow(followingID: String, followerID: String) -> Completable {
        let request = FollowRequestDirector(builder: builder)
            .requestInsertFollow(followingID: followingID, followerID: followerID)

        return networkManger.execute(request)
    }

    func deleteFollow(followingID: String, followerID: String) -> Completable {
        let request = FollowRequestDirector(builder: builder)
            .requestDeleteFollow(followingID: followingID, followerID: followerID)

        return networkManger.execute(request)
    }

    private func contentCount(_ response: URLResponse) -> Int {
        guard let response = response as? HTTPURLResponse,
              let contentRange = response.allHeaderFields["content-range"],
              let contentCountText = String(describing: contentRange).components(separatedBy: "/").last,
              let contentCount = Int(contentCountText) else { return 0 }
        return contentCount
    }
}
