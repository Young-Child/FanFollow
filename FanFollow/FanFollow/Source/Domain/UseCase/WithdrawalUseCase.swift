//
//  WithdrawalUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/16.
//

import Foundation

import RxSwift

protocol WithdrawalUseCase {
    func withdrawal() -> Completable
}

final class DefaultWithdrawalUseCase: WithdrawalUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func withdrawal() -> Completable {
        guard let sessionData = UserDefaults.standard.object(forKey: Constants.session) as? Data,
              let storedSession = try? JSONDecoder.ISODecoder.decode(StoredSession.self, from: sessionData)
        else {
            return Completable.error(SessionError.decoding)
        }
        
        return authRepository.signOut(with: storedSession.accessToken)
            .andThen(authRepository.deleteAuthUserID(with: storedSession.userID))
    }
}

private extension DefaultWithdrawalUseCase {
    enum Constants {
        static let session = "session"
    }
}
