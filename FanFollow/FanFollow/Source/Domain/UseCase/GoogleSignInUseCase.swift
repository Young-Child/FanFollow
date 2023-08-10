//
//  GoogleSignInUseCase.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/09.
//

import RxSwift
import GoogleSignIn

protocol GoogleSignInUseCase: AnyObject {
    typealias Token = String

    func signIn(viewController: UIViewController) -> Observable<Token>
    func signOut()
}

final class DefaultGoogleSignInUseCase: GoogleSignInUseCase {
    func signIn(viewController: UIViewController) -> Observable<Token> {
        return Observable.create { observer in
            GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
                guard error == nil else {
                    observer.onError(error!)
                    return
                }

                guard let signInResult else {
                    observer.onError(GoogleSignInError.signInFailed)
                    return
                }

                signInResult.user.refreshTokensIfNeeded { user, error in
                    guard error == nil else {
                        observer.onError(error!)
                        return
                    }

                    guard let idToken = user?.idToken?.tokenString else {
                        observer.onError(GoogleSignInError.userRefreshFailed)
                        return
                    }

                    observer.onNext(idToken)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}

extension DefaultGoogleSignInUseCase {
    enum GoogleSignInError: Error {
        case signInFailed
        case userRefreshFailed
    }
}
