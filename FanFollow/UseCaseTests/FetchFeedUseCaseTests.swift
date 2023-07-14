//
//  FetchFeedUseCaseTests.swift
//  UseCaseTests
//
//  Created by junho lee on 2023/07/13.
//

import XCTest
import RxSwift

@testable import FanFollow

final class FetchFeedUseCaseTests: XCTestCase {
    private var sut: DefaultFetchFeedUseCase!
    private var postRepository: StubPostRepository!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        postRepository = StubPostRepository()
        sut = DefaultFetchFeedUseCase(postRepository: postRepository)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        postRepository = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    /// 정상적인 조건에서 fetchFollowPosts가 제대로 동작하는 지 테스트
    func test_FetchFollowPostsInNormalCondition() {
        // given
        postRepository.posts = TestData.posts
        postRepository.error = nil
        let followerID = TestData.followerID
        let startRange = TestData.startRange
        let endRange = TestData.endRange

        // when
        let observable = sut.fetchFollowPosts(followerID: followerID, startRange: startRange, endRange: endRange)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value.first?.postID, TestData.postID)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 fetchFollowPosts가 에러를 반환하는 지 테스트
    func test_FetchFollowPostsInErrorCondition() {
        // given
        postRepository.posts = []
        postRepository.error = TestData.error
        let followerID = TestData.followerID
        let startRange = TestData.startRange
        let endRange = TestData.endRange

        // when
        let observable = sut.fetchFollowPosts(followerID: followerID, startRange: startRange, endRange: endRange)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_FetchFollowPostsInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, TestData.error)
        })
        .disposed(by: disposeBag)
    }
}

extension FetchFeedUseCaseTests {
    private enum TestData {
        static let followerID = "5b587434-438c-49d8-ae3c-88bb27a891d4"
        static let startRange = 0
        static let endRange = 9
        static let posts = [
            PostDTO(
                postID: "2936bffa-196f-4c87-92a6-121f7e83f24b",
                userID: "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
                createdData: "2023-07-05 00:53:40.940424+00",
                title: "테스트",
                content: "테스트 컨텐츠",
                imageURLs: nil,
                videoURL: nil,
                nickName: "나미",
                profilePath: "www.naver.com"
            )
        ]
        static let postID = "2936bffa-196f-4c87-92a6-121f7e83f24b"
        static let error = NetworkError.unknown
    }
}
