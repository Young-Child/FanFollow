//
//  StubUserInformationRepository.swift
//  UseCaseTests
//
//  Created by junho lee on 2023/07/13.
//

import Foundation

import RxSwift

@testable import FanFollow

final class StubUserInformationRepository: UserInformationRepository {
    var userInformations = [UserInformationDTO]()
    var userInformation: UserInformationDTO!
    var error: Error?

    func fetchCreatorInformations(
        jobCategory: Int?,
        nickName: String?,
        startRange: Int,
        endRange: Int
    ) -> Observable<[FanFollow.UserInformationDTO]> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.userInformations)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func fetchUserInformation(for userID: String) -> Observable<FanFollow.UserInformationDTO> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.userInformation)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func upsertUserInformation(
        userID: String,
        nickName: String,
        profilePath: String?,
        jobCategory: Int?,
        links: [String]?,
        introduce: String?,
        isCreator: Bool,
        createdAt: Date
    ) -> Completable {
        return Completable.create { observer in
            if let error = self.error {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            return Disposables.create()
        }
    }

    func deleteUserInformation(userID: String) -> Completable {
        return Completable.create { observer in
            if let error = self.error {
                observer(.error(error))
            } else {
                observer(.completed)
            }
            return Disposables.create()
        }
    }

    func fetchRandomCreatorInformations(
        jobCategory: FanFollow.JobCategory,
        count: Int
    ) -> Observable<[FanFollow.UserInformationDTO]> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.userInformations)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func fetchPopularCreatorInformations(
        jobCategory: FanFollow.JobCategory,
        count: Int
    ) -> Observable<[FanFollow.UserInformationDTO]> {
        return Observable.create { observer in
            if let error = self.error {
                observer.onError(error)
            } else {
                observer.onNext(self.userInformations)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
