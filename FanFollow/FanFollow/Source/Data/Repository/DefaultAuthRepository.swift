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
                guard let sessionData = try? JSONEncoder().encode(session) else { return }
                userDefaultsService.set(sessionData, forKey: UserDefaults.Key.session)
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
                guard let sessionData = try? JSONEncoder().encode(session) else { return }
                userDefaultsService.set(sessionData, forKey: UserDefaults.Key.session)
            })
    }

    func signOut(with accessToken: String) -> Completable {
        let request = AuthRequestDirector(builder: builder)
            .requestSignOut(with: accessToken)

        return networkService.execute(request)
            .do(onCompleted: {
                userDefaultsService.removeObject(forKey: UserDefaults.Key.session)
            })
    }

    func storedSession() -> Observable<StoredSession> {
        guard let storedSessionData = userDefaultsService.object(forKey: UserDefaults.Key.session) as? Data else {
            return .error(SessionError.notLoggedIn)
        }
        guard let storedSession = try? JSONDecoder().decode(StoredSession.self, from: storedSessionData) else {
            return .error(SessionError.decoding)
        }
        return storedSession.isValid ? .just(storedSession) : refreshSession(with: storedSession.refreshToken)
    }
    
    func deleteAuthUserID(with userID: String) -> Completable {
        let request = AuthRequestDirector(builder: builder)
            .requestWithdrawal(with: userID)
        
        return networkService.execute(request)
            .do(onCompleted: {
                userDefaultsService.removeObject(forKey: UserDefaults.Key.session)
            })
    }
}
