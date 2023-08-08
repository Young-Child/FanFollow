//
//  PostRepositoryTest.swift
//  NetworkManagerTests
//
//  Created by parkhyo on 2023/07/06.
//

import XCTest

import RxSwift
import RxTest
import RxBlocking
import RxRelay

@testable import FanFollow

final class PostRepositoryTest: XCTestCase {
    private var networkService: StubNetworkService!
    private var successResponse: URLResponse!
    private var failureResponse: URLResponse!
    
    override func setUpWithError() throws {
        let url = URL(string: "https://qacasllvaxvrtwbkiavx.supabase.co/rest/v1/POST")!
        
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
            data: PostDTO.data,
            error: nil,
            response: nil
        )
    }

    override func tearDownWithError() throws {
        successResponse = nil
        failureResponse = nil
        networkService = nil
    }

    ////  Network 연결 없이 정상적으로 PostData들을 방출하는지 확인하는 테스트
    func test_FetchAllPostIsCorrectWhenSendCorrectData() {
        // given
        networkService.response = successResponse
        let postRepository = DefaultPostRepository(networkService)
        let firstPostID = "2936bffa-196f-4c87-92a6-121f7e83f24b"
        let firstUserID = "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2"
        let secondPostID = "aa1f8c34-9b26-4407-b323-691903226867"
        let secondUserID = "5b587434-438c-49d8-ae3c-88bb27a891d4"
        
        // when
        let postListObservable = postRepository.fetchMyPosts(userID: "testUserID", startRange: 0, endRange: 3)
        let value = try? postListObservable.toBlocking().first()!
        
        // then
        let firstResult = value?[0].postID == firstPostID && value?[0].userID == firstUserID
        let secondResult = value?[1].postID == secondPostID && value?[1].userID == secondUserID
        
        XCTAssertEqual(firstResult && secondResult, true)
    }
    
    //// 정상적으로 upsert진행하였을 때 Completable 방출되는지 확인하는 테스트
    func test_UpsertPostIsCorrectWhenSendCorrectData() throws {
        // given
        networkService.response = successResponse
        let postRepository = DefaultPostRepository(networkService)
        
        // when
        let upsertResultObservable = postRepository.upsertPost(
            postID: nil, userID: "testUserID", createdDate: Date(), title: "testTitle",
            content: "testContent", imageURLs: nil, videoURL: nil
        )
        
        // then
        let result = upsertResultObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssert(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "Upsert Fail Error")
        }
    }
    
    //// 정상적으로 delete진행하였을 때 Completable 방출되는지 확인하는 테스트
    func test_DeletePostIsCorrectWhenSendCorrectData() throws {
        // given
        networkService.response = successResponse
        let postRepository = DefaultPostRepository(networkService)
        
        // when
        let deleteResultObservable = postRepository.deletePost(postID: "testPostID")
        
        // then
        let result = deleteResultObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssert(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "Delete Fail Error")
        }
    }
    
    //// PostData 가져올 경우 에러 이벤트가 방출되는지 확인하는 테스트
    func test_FetchAllPostThrowErrorWhenSendCorrectData() throws {
        // given
        networkService.response = failureResponse
        let postRepository = DefaultPostRepository(networkService)
        
        // when
        let postListObservable = postRepository.fetchMyPosts(userID: "testUserID", startRange: 0, endRange: 3)
        
        // when
        let result = postListObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssertThrowsError(NetworkError.unknown, "Fail Test")
        case .failed:
            XCTAssert(true)
        }
    }
}
