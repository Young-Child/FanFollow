//
//  AppleSigningUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/10.
//

import RxSwift

protocol AppleSigningUseCase {
    func signIn(with idToken: String) -> Completable
}

final class DefaultAppleSigningUseCase {
    private let authRepository: AuthRepository
    private let disposeBag = DisposeBag()
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func signIn(with idToken: String) -> Completable {
        return Completable.create { completable in
            let disposable = self.authRepository.storedSession()
                .subscribe(onNext: { storedSession in
                    completable(.completed)
                }, onError: { error in
                    let signInDisposable = self.authRepository.signIn(with: idToken, of: .apple)
                        .subscribe { _ in
                            completable(.completed)
                        } onError: { error in
                                completable(.error(error))
                        }
                    
                    return
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
}

private extension DefaultAppleSigningUseCase {
    enum Constants {
        static let session = "session"
    }
}
