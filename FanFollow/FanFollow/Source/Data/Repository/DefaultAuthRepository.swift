//
//  DefaultAuthRepository.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/08.
//

import Foundation
import RxSwift

struct DefaultAuthRepository: AuthRepository {
    private let networkService: NetworkService
    private let userDefaultsService: UserDefaultsService

    init(networkService: NetworkService, userDefaultsService: UserDefaultsService) {
        self.networkService = networkService
        self.userDefaultsService = userDefaultsService
    }

    @discardableResult
    func signIn(with idToken: String, of provider: Provider) -> Observable<StoredSession> {
        let request = AuthRequestDirector(builder: builder)
            .requestSignIn(with: idToken, of: provider)

        return networkService.data(request)
            .compactMap {
                let sessionDTO = try? JSONDecoder.ISODecoder.decode(SessionDTO.self, from: $0)
                return StoredSession(session: sessionDTO)
            }
            .do(onNext: { session in
                userDefaultsService.set(session, forKey: Constants.session)
            })
    }

    @discardableResult
    func refreshSession(with refreshToken: String) -> Observable<StoredSession> {
        let request = AuthRequestDirector(builder: builder)
            .requestRefreshSession(with: refreshToken)

        return networkService.data(request)
            .compactMap {
                let sessionDTO = try? JSONDecoder.ISODecoder.decode(SessionDTO.self, from: $0)
                return StoredSession(session: sessionDTO)
            }
            .do(onNext: { session in
                userDefaultsService.set(session, forKey: Constants.session)
            })
    }

    func signOut(with accessToken: String) -> Completable {
        let request = AuthRequestDirector(builder: builder)
            .requestSignOut(with: accessToken)

        return networkService.execute(request)
            .do(onCompleted: {
                userDefaultsService.removeObject(forKey: Constants.session)
            })
    }

    func storedSession() -> Observable<StoredSession> {
        guard let storedSession = userDefaultsService.object(forKey: Constants.session) as? StoredSession else {
            return .error(SessionError.notLoggedIn)
        }
        return storedSession.isValid ? .just(storedSession) : refreshSession(with: storedSession.refreshToken)
    }
}

private extension DefaultAuthRepository {
    enum Constants {
        static let session = "session"
    }
}
