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
        return authRepository.storedSession()
            .flatMap { storedSession in
                return self.authRepository.signOut(with: storedSession.accessToken)
                    .andThen(self.authRepository.deleteAuthUserID(with: storedSession.userID))
                    .asObservable()
            }
            .asCompletable()
    }
}
