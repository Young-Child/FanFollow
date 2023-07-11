//
//  FetchChatRoomUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/11.
//

import Foundation
import RxSwift

protocol FetchChatRoomUseCase: AnyObject {
    
}

final class DefaultFetchChatRoomUseCase: FetchChatRoomUseCase {
    private let chatRepository: ChatRepository

    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
}
