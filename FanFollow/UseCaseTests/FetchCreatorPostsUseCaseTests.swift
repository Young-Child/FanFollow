//
//  FetchCreatorPostsUseCaseTests.swift
//  UseCaseTests
//
//  Created by junho lee on 2023/07/14.
//

import XCTest
import RxSwift

@testable import FanFollow

final class FetchCreatorPostsUseCaseTests: XCTestCase {
    private var sut: DefaultFetchCreatorPostsUseCase!
    private var postRepository: StubPostRepository!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        postRepository = StubPostRepository()
        sut = DefaultFetchCreatorPostsUseCase(postRepository: postRepository)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        postRepository = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    /// 정상적인 조건에서 fetchCreatorPosts가 제대로 동작하는 지 테스트
    func test_FetchCreatorPostsInNormalCondition() {
        // given
        postRepository.posts = TestData.posts
        postRepository.error = nil
        let creatorID = TestData.creatorID
        let startRange = TestData.startRange
        let endRange = TestData.endRange

        // when
        let observable = sut.fetchCreatorPosts(creatorID: creatorID, startRange: startRange, endRange: endRange)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value.first?.userID, creatorID)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 fetchCreatorPosts가 에러를 반환하는 지 테스트
    func test_FetchCreatorPostsInErrorCondition() {
        // given
        postRepository.posts = TestData.posts
        postRepository.error = TestData.error
        let creatorID = TestData.creatorID
        let startRange = TestData.startRange
        let endRange = TestData.endRange

        // when
        let observable = sut.fetchCreatorPosts(creatorID: creatorID, startRange: startRange, endRange: endRange)

        // then
        observable.subscribe(onNext: { value in
            XCTFail("test_FetchCreatorPostsInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, TestData.error)
        })
        .disposed(by: disposeBag)
    }
}

extension FetchCreatorPostsUseCaseTests {
    private enum TestData {
        static let creatorID = "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2"
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
        static let error = NetworkError.unknown
    }
}
