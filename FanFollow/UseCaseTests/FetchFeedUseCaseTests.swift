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
    private var imageRepository: StubImageRepository!
    private var authRepository: StubAuthRepository!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        postRepository = StubPostRepository()
        imageRepository = StubImageRepository()
        authRepository = StubAuthRepository()
        sut = DefaultFetchFeedUseCase(
            postRepository: postRepository,
            imageRepository: imageRepository,
            authRepository: authRepository
        )
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        postRepository = nil
        imageRepository = nil
        authRepository = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    /// 정상적인 조건에서 fetchFollowPosts가 제대로 동작하는 지 테스트
    func test_FetchFollowPostsInNormalCondition() {
        // given
        postRepository.posts = TestData.posts
        postRepository.error = nil
        let startRange = TestData.startRange
        let endRange = TestData.endRange

        // when
        let observable = sut.fetchFollowPosts(startRange: startRange, endRange: endRange)

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
        let startRange = TestData.startRange
        let endRange = TestData.endRange

        // when
        let observable = sut.fetchFollowPosts(startRange: startRange, endRange: endRange)

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
        static let startRange = 0
        static let endRange = 9
        static let posts = [
            PostDTO(
                postID: "2936bffa-196f-4c87-92a6-121f7e83f24b",
                userID: "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
                createdDate: Date(),
                title: "테스트",
                content: "테스트 컨텐츠",
                imageURLs: nil,
                videoURL: nil,
                nickName: "나미",
                profilePath: "www.naver.com",
                isLiked: true,
                likeCount: 2
            )
        ]
        static let postID = "2936bffa-196f-4c87-92a6-121f7e83f24b"
        static let error = NetworkError.unknown
    }
}
