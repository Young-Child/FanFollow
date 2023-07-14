//
//  AccessChatRoomUseCaseTests.swift
//  UseCaseTests
//
//  Created by parkhyo on 2023/07/14.
//

import XCTest

import RxSwift
import RxTest
import RxBlocking

@testable import FanFollow

final class AccessChatRoomUseCaseTests: XCTestCase {
    private var accessChatRoomUseCase: AccessChatRoomUseCase!
    private var chatRepository: StubChatRepository!
    private var error: Error!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        chatRepository = StubChatRepository()
        accessChatRoomUseCase = DefaultAccessChatRoomUseCase(chatRepository: chatRepository)
    }

    override func tearDownWithError() throws {
        chatRepository = nil
        accessChatRoomUseCase = nil
        error = nil
        try super.tearDownWithError()
    }
        
    ////  채팅방 리스트를 정상적으로 받아오는지에 대한 테스트 수행
    func test_FetchChatRoomListIsCorrectWhenSendCorrectData() {
        // given
        chatRepository.error = nil
        let userID = "CreatorTestID"
        
        // when
        let chatListObsevable = accessChatRoomUseCase.fetchChatRoomList(userID: userID)
        
        // then
        let result = try? chatListObsevable.toBlocking().first()
        
        XCTAssertEqual(result?.count, 1)
    }
    
    //// 채팅방 나가기를 정상적으로 수행했을 경우 정상적인 반환값이 방출되는지에 대한 테스트 수행
    func test_LeaveChatRoomIsCorrectWhenSendCorrectData() throws {
        // given
        chatRepository.error = nil
        let chatID = "ChatTestID"
        let userID = "CreatorTestID"
        
        // when
        let leaveObservalble = accessChatRoomUseCase.leaveChatRoom(
            chatID: chatID,
            userID: userID,
            isCreator: false
        )
        
        // then
        let result = leaveObservalble.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssertTrue(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "We expected Completed Event, But Occur Error Event")
        }
    }
    
    //// 채팅방 삭제를 정상적으로 수행했을 경우 정상적인 반환값이 방출되는지에 대한 테스트 수행
    func test_DeleteChatRoomListIsCorrectWhenSendCorrectData() throws {
        // given
        chatRepository.error = nil
        let chatID = "ChatTestID"
        
        // when
        let deleteChatRoomObservable = accessChatRoomUseCase.deleteChatRoom(chatID: chatID)
        
        // then
        let result = deleteChatRoomObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssert(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "We expected Completed Event, But Occur Error Event")
        }
    }
    
    //// 채팅방 리스트 불러오기를 정상적으로 수행하지 않고, 에러 반환 값이 방출되는지에 대한 테스트 수행
    func test_FetchChatRoomListIsErrorWhenSendCorrectData() throws {
        // given
        chatRepository.error = NetworkError.unknown
        let userID = "CreatorTestID"
        
        // when
        let chatListObsevable = accessChatRoomUseCase.fetchChatRoomList(userID: userID)
        
        // then
        let result = chatListObsevable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssertThrowsError(NetworkError.unknown, "We expected Error Event, But Occur OnCompleted Event")
        case .failed:
            XCTAssertTrue(true)
        }
    }
    
    //// 채팅방 삭제를 정상적으로 수행하지 않고, 에러 반환값이 방출되는지에 대한 테스트 수행
    func test_DeleteChatRoomListIsErrorWhenSendCorrectData() throws {
        // given
        chatRepository.error = NetworkError.unknown
        let chatID = "ChatTestID"
        
        // when
        let deleteChatRoomObservable = accessChatRoomUseCase.deleteChatRoom(chatID: chatID)
        
        // then
        let result = deleteChatRoomObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssertThrowsError(NetworkError.unknown, "We expected Error Event, But Occur OnCompleted Event")
        case .failed:
            XCTAssertTrue(true)
        }
    }
}
