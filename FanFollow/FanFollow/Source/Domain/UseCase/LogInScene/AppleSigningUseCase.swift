//
//  AppleSigningUseCase.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/10.
//

import RxSwift

protocol AppleSigningUseCase {
    func logIn(with idToken: String) -> Observable<StoredSession>
}

final class DefaultAppleSigningUseCase: AppleSigningUseCase {
    private let authRepository: AuthRepository
    private let disposeBag = DisposeBag()
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func logIn(with idToken: String) -> Observable<StoredSession>  {
        return authRepository.storedSession()
            .catch { error in
                return self.authRepository.signIn(with: idToken, of: .apple)
            }
    }
}

// Constants
private extension DefaultAppleSigningUseCase {
    enum Constants {
        static let session = "session"
    }
}
