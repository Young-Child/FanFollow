//
//  ChatServiceTests.swift
//  ServiceTests
//
//  Copyright (c) 2023 Minii All rights reserved.

import XCTest

import RxBlocking
import RxTest

@testable import FanFollow

final class ChatServiceTests: XCTestCase {
    private var successResponse: URLResponse!
    private var failureResponse: URLResponse!
    private var networkManager: StubNetworkManager!
    
    override func setUpWithError() throws {
        let url = URL(string: "https://qacasllvaxvrtwbkiavx.supabase.co/rest/v1/CHAT_ROOM?select=chat_id")!
        
        self.successResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        self.failureResponse = HTTPURLResponse(
            url: url,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        let stubNetworkManager = StubNetworkManager(
            data: ChatDTO.data,
            error: nil,
            response: nil
        )
        
        networkManager = stubNetworkManager
    }
    
    override func tearDownWithError() throws {
        successResponse = nil
        failureResponse = nil
        networkManager = nil
    }
    
    /// 정상적인 사용자ID를 전달하였을 때 정상적인 데이터를 반환하는지에 대한 테스트
    func test_FetchChattingListIsCorrectWhenSendCorrectData() {
        // given
        let userID = "5b587434-438c-49d8-ae3c-88bb27a891d4"
        networkManager.response = successResponse
        
        // when
        let chatService = DefaultChatService(networkManager: self.networkManager)
        let chatListObservable = chatService.fetchChattingList(userID: userID)
        
        // then
        let value = try? chatListObservable.toBlocking().first()!.first!
        let result = (value?.fanId == userID || value?.creatorId == userID)
        
        XCTAssertEqual(result, true)
    }
    
    /// 비정상적인 사용자ID를 전달하였을 때 에러를 방출하는지에 대한 테스트
    func test_FetchChattingListThrowErrorWhenSendWrongData() throws {
        // given
        let userID = ""
        self.networkManager.response = failureResponse
        self.networkManager.error = NetworkError.unknown
        
        //when
        let chatService = DefaultChatService(networkManager: self.networkManager)
        let chatListObservable = chatService.fetchChattingList(userID: userID)
        
        // then
        do {
            let _ = try chatListObservable.toBlocking().first()
        } catch let error {
            let error = error as? NetworkError
            let expected = NetworkError.unknown
            
            XCTAssertEqual(error, expected)
        }
    }
    
    /// 정상적인 사용자ID를 전달하였을 때 완료 이벤트가 방출되는가에 대한 테스트
    func test_CreateNewChatRoomIsCompletedWhenSendCorrectData() throws {
        // given
        let fanID = "5b587434-438c-49d8-ae3c-88bb27a891d4"
        let creatorID = "5b587434-438c-49d8-ae3c-88bb27a891d4"
        networkManager.response = successResponse
        
        //when
        let chatService = DefaultChatService(networkManager: self.networkManager)
        let observable = chatService.createNewChatRoom(from: fanID, to: creatorID)
        
        //then
        let result = observable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssert(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "We expected Completed Event, But Occur Error Event")
        }
    }
}
