//
//  PostServiceTest.swift
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

final class PostServiceTest: XCTestCase {
    private var postService: PostService!
    private var networkManager: StubNetworkManager!
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
        
        networkManager = StubNetworkManager(
            data: PostDTO.data,
            error: nil,
            response: nil
        )
    }

    override func tearDownWithError() throws {
        successResponse = nil
        failureResponse = nil
        networkManager = nil
    }

    ////  Network 연결 없이 정상적으로 PostData들을 불러오는지 확인
    func test_fetchAllPostCompleted() {
        // given
        networkManager.response = successResponse
        let postService = DefaultPostService(networkManager: networkManager)
        let firstPostID = "2936bffa-196f-4c87-92a6-121f7e83f24b"
        let firstUserID = "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2"
        let secondPostID = "aa1f8c34-9b26-4407-b323-691903226867"
        let secondUserID = "5b587434-438c-49d8-ae3c-88bb27a891d4"
        
        // when
        let postListObservable = postService.fetchAllPost(startRange: 0, endRange: 3)
        let value = try? postListObservable.toBlocking().first()!
        
        // then
        let firstResult = value?[0].postID == firstPostID && value?[0].userID == firstUserID
        let secondResult = value?[1].postID == secondPostID && value?[1].userID == secondUserID
        
        XCTAssertEqual(firstResult && secondResult, true)
    }
    
    //// 정상적으로 upsert진행하였을 때 Completable  확인
    func test_upsertPostCompleted() throws {
        // given
        networkManager.response = successResponse
        let postService = DefaultPostService(networkManager: networkManager)
        
        // when
        let upsertResultObservable = postService.upsertPost(
            postID: nil, userID: "testUserID", createdDate: "testData", title: "testTitle",
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
    
    //// 정상적으로 delete진행하였을 때 Completable 확인
    func test_deletePostCompleted() throws {
        // given
        networkManager.response = successResponse
        let postService = DefaultPostService(networkManager: networkManager)
        
        // when
        let deleteResultObservable = postService.deletePost(postID: "testPostID")
        
        // then
        let result = deleteResultObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssert(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "Delete Fail Error")
        }
    }
    
    //// PostData 가져올 경우 에러 방출 확인
    func test_fetchAllPostFailure() throws {
        // given
        networkManager.response = failureResponse
        let postService = DefaultPostService(networkManager: networkManager)
        
        // when
        let postListObservable = postService.fetchAllPost(startRange: 0, endRange: 3)
        
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
