//
//  FollowRepositoryTests.swift
//  NetworkManagerTests
//
//  Created by junho lee on 2023/07/06.
//

import XCTest
import RxSwift
@testable import FanFollow

final class FollowRepositoryTests: XCTestCase {
    private var sut: DefaultFollowRepository!
    private var networkService: StubNetworkService!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        networkService = StubNetworkService()
        sut = DefaultFollowRepository(networkService)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        networkService = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    /// 정상적인 조건에서 fetchFollowers가 제대로 동작하는 지 테스트
    func test_FetchFollowersInNormalCondition() {
        // given
        networkService.data = TestData.followData
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let followingID = TestData.followingID
        let startRange = 0
        let endRange = 9

        // when
        let observable = sut.fetchFollowers(followingID: followingID, startRange: startRange, endRange: endRange)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value.first?.followingID, followingID)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 fetchFollowers가 에러를 반환하는 지 테스트
    func test_FetchFollowersInErrorCondition() {
        // given
        networkService.data = nil
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let followingID = TestData.followingID
        let startRange = 0
        let endRange = 9

        // when
        let observable = sut.fetchFollowers(followingID: followingID, startRange: startRange, endRange: endRange)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_FetchFollowersInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 fetchFollowings가 제대로 동작하는 지 테스트
    func test_FetchFollowingsInNormalCondition() {
        // given
        networkService.data = TestData.followData
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let followerID = TestData.followerID
        let startRange = TestData.startRange
        let endRange = TestData.endRange

        // when
        let observable = sut.fetchFollowings(followerID: followerID, startRange: startRange, endRange: endRange)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value.first?.followerID, followerID)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 fetchFollowings가 에러를 반환하는 지 테스트
    func test_FetchFollowingsInErrorCondition() {
        // given
        networkService.data = nil
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let followerID = TestData.followerID
        let startRange = TestData.startRange
        let endRange = TestData.endRange

        // when
        let observable = sut.fetchFollowings(followerID: followerID, startRange: startRange, endRange: endRange)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_FetchFollowingsInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 fetchFollowerCount가 제대로 동작하는 지 테스트
    func test_FetchFollowerCountInNormalCondition() {
        // given
        networkService.data = TestData.countData
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let followingID = TestData.followingID
        let count = TestData.count

        // when
        let observable = sut.fetchFollowerCount(followingID: followingID)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value, count)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 fetchFollowerCount가 에러를 반환하는 지 테스트
    func test_FetchFollowerCountInErrorCondition() {
        // given
        networkService.data = nil
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let followingID = TestData.followingID

        // when
        let observable = sut.fetchFollowerCount(followingID: followingID)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_FetchFollowerCountInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 fetchFollowingCount가 제대로 동작하는 지 테스트
    func test_FetchFollowingCountInNormalCondition() {
        // given
        networkService.data = TestData.countData
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let followerID = TestData.followerID
        let count = TestData.count

        // when
        let observable = sut.fetchFollowingCount(followerID: followerID)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value, count)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 fetchFollowingCount가 에러를 반환하는 지 테스트
    func test_FetchFollowingCountInErrorCondition() {
        // given
        networkService.data = nil
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let followerID = TestData.followerID

        // when
        let observable = sut.fetchFollowingCount(followerID: followerID)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_FetchFollowingCountInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 checkFollow가 제대로 동작하는 지 테스트
    func test_CheckFollowInNormalCondition() {
        // given
        networkService.data = TestData.countData
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let followingID = TestData.followingID
        let followerID = TestData.followerID
        let isFollow = TestData.isFollow

        // when
        let observable = sut.checkFollow(followingID: followingID, followerID: followerID)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value, isFollow)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 checkFollow가 에러를 반환하는 지 테스트
    func test_CheckFollowInErrorCondition() {
        // given
        networkService.data = nil
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let followingID = TestData.followingID
        let followerID = TestData.followerID

        // when
        let observable = sut.checkFollow(followingID: followingID, followerID: followerID)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_CheckFollowInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 insertFollow가 제대로 동작하는 지 테스트
    func test_InsertFollowInNormalCondition() {
        // given
        networkService.data = Data()
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let followingID = TestData.followingID
        let followerID = TestData.followerID

        // when
        let observable = sut.insertFollow(followingID: followingID, followerID: followerID)

        // then
        observable.subscribe(onCompleted: {
            XCTAssertTrue(true)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 insertFollow가 에러를 반환하는 지 테스트
    func test_InsertFollowInErrorCondition() {
        // given
        networkService.data = nil
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let followingID = TestData.followingID
        let followerID = TestData.followerID

        // when
        let observable = sut.insertFollow(followingID: followingID, followerID: followerID)

        // then
        observable.subscribe(onCompleted: {
            XCTFail("test_InsertFollowInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 deleteFollow가 제대로 동작하는 지 테스트
    func test_DeleteFollowInNormalCondition() {
        // given
        networkService.data = Data()
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let followingID = TestData.followingID
        let followerID = TestData.followerID

        // when
        let observable = sut.deleteFollow(followingID: followingID, followerID: followerID)

        // then
        observable.subscribe(onCompleted: {
            XCTAssertTrue(true)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 deleteFollow가 에러를 반환하는 지 테스트
    func test_DeleteFollowInErrorCondition() {
        // given
        networkService.data = nil
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let followingID = TestData.followingID
        let followerID = TestData.followerID

        // when
        let observable = sut.deleteFollow(followingID: followingID, followerID: followerID)

        // then
        observable.subscribe(onCompleted: {
            XCTFail("test_DeleteFollowInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }
}

extension FollowRepositoryTests {
    private enum TestData {
        static let followerID = "5b587434-438c-49d8-ae3c-88bb27a891d4"
        static let followingID = "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2"
        static let startRange = 0
        static let endRange = 9
        static let followData = """
        [
            {
                "follower_id": "5b587434-438c-49d8-ae3c-88bb27a891d4",
                "following_id": "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
                "created_at": "2023-07-04T11:58:51.318123+00:00",
                "follow_id": "93de0d53-5c9a-48fa-9283-c3f1b1497c7c",
                "USER_INFORMATION": {
                    "user_id": "5b587434-438c-49d8-ae3c-88bb27a891d4",
                    "nick_name": "나가",
                    "profile_path": null,
                    "job_category": null,
                    "links": null,
                    "introduce": null,
                    "is_creator": false,
                    "created_at": "2023-07-04T08:40:32+00:00"
                }
            }
        ]
        """.data(using: .utf8)
        static let count = 1
        static let isFollow = true
        static let countData = """
        [
            {
                "count": 1
            }
        ]
        """.data(using: .utf8)
        static let normalResponse = HTTPURLResponse(
            url: URL(staticString: "test.com"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        static let errorResponse = HTTPURLResponse(
            url: URL(staticString: "test.com"),
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
    }
}
