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

    func fetchFollowerList(followingId: String, startRange: Int, endRange: Int) -> Observable<[FollowDTO]> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowerList(followingId, startRange: startRange, endRange: endRange)

        return networkManger.data(request)
            .compactMap { try? JSONDecoder().decode([FollowDTO].self, from: $0) }
    }

    func fetchFollowingList(followerId: String, startRange: Int, endRange: Int) -> Observable<[FollowDTO]> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowingList(followerId, startRange: startRange, endRange: endRange)

        return networkManger.data(request)
            .compactMap { try? JSONDecoder().decode([FollowDTO].self, from: $0) }
    }

    func fetchFollowerCount(followingId: String) -> RxSwift.Observable<Int> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowCount(followingId: followingId)

        return networkManger.response(request)
            .map { contentCount($0.response) }
    }

    func fetchFollowingCount(followerId: String) -> RxSwift.Observable<Int> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowCount(followerId: followerId)

        return networkManger.response(request)
            .map { contentCount($0.response) }
    }

    func checkFollow(followingId: String, followerId: String) -> RxSwift.Observable<Bool> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowCount(followingId: followingId, followerId: followerId)

        return networkManger.response(request)
            .map { contentCount($0.response) > 0 ? true : false }
    }

    func insertFollow(followerId: String, followingId: String) -> Completable {
        let request = FollowRequestDirector(builder: builder)
            .requestInsertFollow(followerId: followerId, followingId: followingId)

        return networkManger.execute(request)
    }

    func deleteFollow(followerId: String, followingId: String) -> Completable {
        let request = FollowRequestDirector(builder: builder)
            .requestDeleteFollow(followerId: followerId, followingId: followingId)

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
