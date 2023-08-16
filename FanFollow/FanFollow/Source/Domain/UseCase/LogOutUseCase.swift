//
//  LogOutUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/16.
//

import Foundation

import RxSwift

protocol LogOutUseCase {
    func logOut() -> Completable
}

final class DefaultLogOutUseCase: LogOutUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func logOut() -> Completable {
        guard let sessionData = UserDefaults.standard.object(forKey: Constants.session) as? Data,
              let storedSession = try? JSONDecoder.ISODecoder.decode(StoredSession.self, from: sessionData) else {
            return Completable.error(SessionError.decoding)
        }
        
        return authRepository.signOut(with: storedSession.accessToken)
    }
}

private extension DefaultLogOutUseCase {
    enum Constants {
        static let session = "session"
    }
}
