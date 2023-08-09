//
//  LikeRepositoryTests.swift
//  ServiceTests
//
//  Created by parkhyo on 2023/07/07.
//

import XCTest

import RxSwift
import RxTest
import RxBlocking
import RxRelay

@testable import FanFollow

final class LikeRepositoryTests: XCTestCase {
    private var networkService: StubNetworkService!
    private var successResponse: URLResponse!
    private var failureResponse: URLResponse!
    
    override func setUpWithError() throws {
        let url = URL(string: "https://qacasllvaxvrtwbkiavx.supabase.co/rest/v1/LIKE")!
        
        successResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        failureResponse = HTTPURLResponse(
            url: url,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )
        
        networkService = StubNetworkService(
            data: PostDTO.countData,
            error: nil,
            response: nil
        )
    }

    override func tearDownWithError() throws {
        successResponse = nil
        failureResponse = nil
        networkService = nil
    }

    //// 정상적으로 데이터 요청을 했을 때 정상적인 Count값을 방출하는지 확인하는 테스트
    func test_FetchPostLikeCountIsCorrectWhenSendCorrectData() {
        // given
        networkService.response = successResponse
        let likeRepository = DefaultLikeRepository(networkService)
        let postID = "2936bffa-196f-4c87-92a6-121f7e83f24b"
        let dataCount = 2
        
        // when
        let likeCountObservable = likeRepository.fetchPostLikeCount(postID: postID)
        
        // then
        let result = try? likeCountObservable.toBlocking().first()
        XCTAssert(result == dataCount)
    }

    //// 정상적으로 Like 데이터를 생성했을 때 올바른 Completable이 방출되는지 확인하는 테스트
    func test_CreatePostLikeIsCorrectWhenSendCorrectData() throws {
        // given
        networkService.response = successResponse
        let likeRepository = DefaultLikeRepository(networkService)

        // when
        let createLikeObservable = likeRepository.createPostLike(postID: "testPostID", userID: "testUserID")
        
        // then
        let result = createLikeObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssert(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "Create LikeData Fail")
        }
    }
    
    //// 정상적으로 Like 데이터를 삭제했을 때 올바른 Completable이 방출되는지 확인하는 테스트
    func test_DeletePostLikeIsCorrectWhenSendCorrectData() {
        // given
        networkService.response = successResponse
        let likeRepository = DefaultLikeRepository(networkService)

        // when
        let createLikeObservable = likeRepository.deletePostLike(postID: "testPostID", userID: "testUserID")
        
        // then
        let result = createLikeObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssert(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "Delete LikeData Fail")
        }
    }
    
    //// 데이터 갯수를 불러올때, 올바르지 않은 데이터 값에 대해서 에러가 방출되는지 확인하는 테스트
    func test_FetchPostLikeCountIsErrorWhenSendCorrectData() throws {
        // given
        networkService.response = successResponse
        networkService.data = PostDTO.data
        let likeRepository = DefaultLikeRepository(networkService)
        let postID = "2936bffa-196f-4c87-92a6-121f7e83f24b"
        
        // when
        let likeCountObservable = likeRepository.fetchPostLikeCount(postID: postID)
        
        // then
        let result = likeCountObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssertThrowsError(NetworkError.unknown, "Fail Test")
        case .failed:
            XCTAssert(true)
        }
    }
}
