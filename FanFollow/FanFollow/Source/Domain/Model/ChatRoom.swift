//
//  ChatRoom.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/11.
//

import Foundation

struct ChatRoom {
    var chatID: String
    var partnerID: String?
    var partnerNickName: String?
    var partnerProfilePath: String?
    var isAccept: Bool
    
    init(_ chatDTO: ChatDTO, userID: String) {
        chatID = chatDTO.chatID
        partnerID = chatDTO.fanID == userID ? chatDTO.creatorID : chatDTO.fanID
        partnerNickName = chatDTO.fanID == userID ? chatDTO.creatorNickName : chatDTO.fanNickName
        partnerProfilePath = chatDTO.fanID == userID ? chatDTO.creatorProfilePath : chatDTO.fanProfilePath
        isAccept = chatDTO.isAccept
    }
}
