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
        guard let sessionData = UserDefaults.standard.object(forKey: UserDefaults.Key.session) as? Data,
              let storedSession = try? JSONDecoder().decode(StoredSession.self, from: sessionData)
        else {
            return Completable.error(SessionError.decoding)
        }
        
        return authRepository.signOut(with: storedSession.accessToken)
            .andThen(authRepository.deleteAuthUserID(with: storedSession.userID))
    }
}
