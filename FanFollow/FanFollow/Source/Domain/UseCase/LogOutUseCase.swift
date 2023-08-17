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
        return authRepository.storedSession()
            .flatMap { storedSession in
                return self.authRepository.signOut(with: storedSession.accessToken)
                    .asObservable()
            }
            .asCompletable()
    }
}
