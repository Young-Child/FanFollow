//
//  AccessChatRoomUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/11.
//

import RxSwift

protocol AccessChatRoomUseCase: AnyObject {
    func fetchChatRoomList(userID: String) -> Observable<[ChatRoom]>
    func leaveChatRoom(chatID: String, userID: String, isCreator: Bool) -> Observable<Void>
    func deleteChatRoom(chatID: String) -> Completable
}

final class DefaultAccessChatRoomUseCase: AccessChatRoomUseCase {
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    func fetchChatRoomList(userID: String) -> Observable<[ChatRoom]> {
        let chatList = chatRepository.fetchChattingList(userID: userID)
        
        return chatList.map { chatDTOList in
            chatDTOList.map { chatDTO in
                return ChatRoom(chatDTO, userID: userID)
            }
        }
    }
    
    // 추후 IndexPath로 변경
    func leaveChatRoom(chatID: String, userID: String, isCreator: Bool) -> Observable<Void> {
        return chatRepository.leaveChatRoom(to: chatID, userID: userID, isCreator: isCreator)
            .map { _ in return }
    }
    
    func deleteChatRoom(chatID: String) -> Completable {
        return chatRepository.deleteChatRoom(to: chatID)
    }
}
