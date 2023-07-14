//
//  StubChatRepository.swift
//  UseCaseTests
//
//  Created by parkhyo on 2023/07/14.
//

import RxSwift

@testable import FanFollow

final class StubChatRepository: ChatRepository {
    private let datas = [ChatDTO.stubData()]
    var error: Error?
    
    func fetchChattingList(userID: String) -> Observable<[ChatDTO]> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.datas)
            }
            
            return Disposables.create()
        }
    }
    
    func createNewChatRoom(from fanID: String, to creatorID: String) -> Completable {
        return Completable.create { observer in
            if let error = self.error {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            
            return Disposables.create()
        }
    }
    
    func leaveChatRoom(to chatID: String, userID: String, isCreator: Bool) -> Observable<Void> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(Void())
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func deleteChatRoom(to chatID: String) -> Completable {
        return Completable.create { observer in
            if let error = self.error {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            
            return Disposables.create()
        }
    }
}

private extension ChatDTO {
    static func stubData() -> Self {
        return ChatDTO(
            creatorID: "CreatorTestID",
            creatorNickName: "CreatorTestNickName",
            creatorProfilePath: "CreatorTestProfilePath",
            fanID: "FanTestID",
            fanNickName: "FanTestNickName",
            fanProfilePath: "FabTestProfilePath"
        )
    }
}
