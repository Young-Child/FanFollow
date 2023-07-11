//
//  FetchChatRoomUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/11.
//

import Foundation
import RxSwift

protocol FetchChatRoomUseCase: AnyObject {
    func fetchChatRoomList(userID: String) -> Observable<[ChatRoom]>
    func leaveChatRoom(chatID: String, userID: String, isCreator: Bool) -> Observable<Void>
    func deleteChatRoom(chatID: String) -> Completable
}

final class DefaultFetchChatRoomUseCase: FetchChatRoomUseCase {
    private let chatRepository: ChatRepository

    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    func fetchChatRoomList(userID: String) -> Observable<[ChatRoom]> {
        let chatList = chatRepository.fetchChattingList(userID: userID)
        
        return chatList.map { datas in
            datas.map { data in
                let partnerID = data.fanID == userID ? data.creatorID : data.fanID
                let partnerNickName = data.fanID == userID ? data.creatorNickName : data.fanNickName
                let partnerProfilePath = data.fanID == userID ? data.creatorProfilePath : data.fanProfilePath
                
                return ChatRoom(
                    chatID: data.chatID,
                    partnerID: partnerID,
                    partnerNickName: partnerProfilePath,
                    isAccept: data.isAccept
                )
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
