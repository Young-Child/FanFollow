//
//  UpdateUserInformationUseCase.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol UpdateUserInformationUseCase: AnyObject {
    func updateUserInformation() -> Observable<Void>
}

final class DefaultUpdateUserInformationUseCase: UpdateUserInformationUseCase {
    private let userInformationRepository: UserInformationRepository
    
    init(userInformationRepository: UserInformationRepository) {
        self.userInformationRepository = userInformationRepository
    }
    
    func updateUserInformation() -> Observable<Void> {
    }
}
