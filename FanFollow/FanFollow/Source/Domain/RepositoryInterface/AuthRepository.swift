//
//  AuthRepository.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/08.
//

import Foundation
import RxSwift

protocol AuthRepository: SupabaseEndPoint {
    func signIn(with idToken: String, of provider: Provider) -> Observable<StoredSession>
    func refreshSession(with refreshToken: String) -> Observable<StoredSession>
    func signOut(with accessToken: String) -> Completable
    func storedSession() -> Observable<StoredSession>
}
