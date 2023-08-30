//
//  ChangeLikeUseCaseTests.swift
//  UseCaseTests
//
//  Created by junho lee on 2023/07/13.
//

import XCTest

import RxSwift

@testable import FanFollow

final class ChangeLikeUseCaseTests: XCTestCase {
    private var sut: DefaultChangeLikeUseCase!
    private var likeRepository: StubLikeRepository!
    private var authRepository: StubAuthRepository!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        likeRepository = StubLikeRepository()
        authRepository = StubAuthRepository()
        sut = DefaultChangeLikeUseCase(likeRepository: likeRepository, authRepository: authRepository)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        likeRepository = nil
        authRepository = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    /// 정상적인 조건에서 checkPostLiked가 제대로 동작하는 지 테스트
    func test_CheckPostLikedInNormalCondition() {
        // given
        likeRepository.count = TestData.count
        likeRepository.error = nil
        let postID = TestData.postID

        // when
        let observable = sut.checkPostLiked(postID: postID)

        // then
        observable.subscribe(onNext: { liked in
            XCTAssertTrue(liked)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 checkPostLiked가 에러를 반환하는 지 테스트
    func test_CheckPostLikedInErrorCondition() {
        // given
        likeRepository.error = TestData.error
        let postID = TestData.postID

        // when
        let observable = sut.checkPostLiked(postID: postID)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_CheckPostLikedInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, TestData.error)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 fetchPostLikeCount가 제대로 동작하는 지 테스트
    func test_FetchPostLikeCountInNormalCondition() {
        // given
        likeRepository.count = TestData.count
        likeRepository.error = nil
        let postID = TestData.postID

        // when
        let observable = sut.fetchPostLikeCount(postID: postID)

        // then
        observable.subscribe(onNext: { count in
            XCTAssertEqual(count, TestData.count)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 fetchPostLikeCount가 에러를 반환하는 지 테스트
    func test_FetchPostLikeCountInErrorCondition() {
        // given
        likeRepository.error = TestData.error
        let postID = TestData.postID

        // when
        let observable = sut.fetchPostLikeCount(postID: postID)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_FetchPostLikeCountInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, TestData.error)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 togglePostLike가 createPostLike를 호출하는 지 테스트
    func test_TogglePostLikeCallCreatePostLikeInNormalCondition() {
        //given
        likeRepository.count = TestData.emptyCount
        likeRepository.error = nil
        let postID = TestData.postID

        // when
        let observable = sut.togglePostLike(postID: postID)

        // then
        observable.subscribe(onCompleted: {
            XCTAssertEqual(self.likeRepository.isCreatePostLikeCalled, true)
            XCTAssertEqual(self.likeRepository.isDeletePostLikeCalled, false)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 togglePostLike가 deletePostLike를 호출하는 지 테스트
    func test_TogglePostLikeCallDeletePostLikeInNormalCondition() {
        //given
        likeRepository.count = TestData.count
        likeRepository.error = nil
        let postID = TestData.postID

        // when
        let observable = sut.togglePostLike(postID: postID)

        // then
        observable.subscribe(onCompleted: {
            XCTAssertEqual(self.likeRepository.isCreatePostLikeCalled, false)
            XCTAssertEqual(self.likeRepository.isDeletePostLikeCalled, true)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 togglePostLike가 에러를 반환하는 지 테스트
    func test_TogglePostLikeInErrorCondition() {
        //given
        likeRepository.error = TestData.error
        let postID = TestData.postID

        // when
        let observable = sut.togglePostLike(postID: postID)

        // then
        observable.subscribe(onCompleted: {
            XCTFail("test_TogglePostLikeInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }
}

extension ChangeLikeUseCaseTests {
    private enum TestData {
        static let emptyCount = 0
        static let count = 1
        static let postID = "2936bffa-196f-4c87-92a6-121f7e83f24b"
        static let error = NetworkError.unknown
    }
}
