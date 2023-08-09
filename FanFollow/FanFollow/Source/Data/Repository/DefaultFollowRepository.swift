//
//  DefaultFollowRepository.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/03.
//

import Foundation

import RxSwift

struct DefaultFollowRepository: FollowRepository {
    private let networkService: NetworkService

    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchFollowers(followingID: String, startRange: Int, endRange: Int) -> Observable<[FollowDTO]> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowerList(followingID, startRange: startRange, endRange: endRange)

        return networkService.data(request)
            .compactMap { try? JSONDecoder.ISODecoder.decode([FollowDTO].self, from: $0) }
    }

    func fetchFollowings(followerID: String, startRange: Int, endRange: Int) -> Observable<[FollowDTO]> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowingList(followerID, startRange: startRange, endRange: endRange)

        return networkService.data(request)
            .compactMap { try? JSONDecoder.ISODecoder.decode([FollowDTO].self, from: $0) }
    }

    func fetchFollowerCount(followingID: String) -> Observable<Int> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowCount(followingID: followingID)

        return networkService.data(request)
            .compactMap { try contentCount($0) }
    }

    func fetchFollowingCount(followerID: String) -> Observable<Int> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowCount(followerID: followerID)

        return networkService.data(request)
            .compactMap { try contentCount($0) }
    }

    func checkFollow(followingID: String, followerID: String) -> Observable<Bool> {
        let request = FollowRequestDirector(builder: builder)
            .requestFollowCount(followingID: followingID, followerID: followerID)

        return networkService.data(request)
            .compactMap { try contentCount($0) }
            .map { $0 > 0 }
    }

    func insertFollow(followingID: String, followerID: String) -> Completable {
        let request = FollowRequestDirector(builder: builder)
            .requestInsertFollow(followingID: followingID, followerID: followerID)

        return networkService.execute(request)
    }

    func deleteFollow(followingID: String, followerID: String) -> Completable {
        let request = FollowRequestDirector(builder: builder)
            .requestDeleteFollow(followingID: followingID, followerID: followerID)

        return networkService.execute(request)
    }

    private func contentCount(_ data: Data) throws -> Int? {
        guard let value = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]],
              let count = value.first?.first?.value as? Int else {
            throw NetworkError.unknown
        }
        return count
    }
}
