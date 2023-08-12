//
//  StubAuthRepository.swift
//  UseCaseTests
//
//  Created by parkhyo on 2023/08/12.
//

import Foundation

import RxSwift

@testable import FanFollow

final class StubAuthRepository: AuthRepository {
    var error: Error?
    
    func signIn(with idToken: String, of provider: Provider) -> Observable<StoredSession> {
        guard let storedSessionData = StoredSession(session: SessionDTO.testData(idToken: idToken)) else {
            return Observable.error(error!)
        }
        
        return Observable.just(storedSessionData)
    }
    
    func refreshSession(with refreshToken: String) -> Observable<StoredSession> {
        guard let storedSessionData = StoredSession(session: SessionDTO.testData(idToken: refreshToken)) else {
            return Observable.error(error!)
        }
        
        return Observable.just(storedSessionData)
    }
    
    func signOut(with accessToken: String) -> Completable {
        return Completable.create { observer in
            if let error = self.error {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    func storedSession() -> Observable<StoredSession> {
        guard let storedSessionData = StoredSession(session: SessionDTO.testData(idToken: "Stored")) else {
            return Observable.error(error!)
        }
        
        return Observable.just(storedSessionData)
    }
}

private extension SessionDTO {
    static func testData(idToken: String) -> Self {
        return SessionDTO(
            accessToken: idToken,
            refreshToken: idToken, expiresIn: 3600.00, user: UserDTO(id: "TestUser")
        )
    }
}
