//
//  BlockUserViewModel.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

class BlockUserViewModel: ViewModel {
    struct Input {
        var didTapBlockUserButton: Observable<Void>
    }
    
    struct Output {
        var didBlockUser: Completable
    }
    
    private let userID: String
    private let manageBlockUserUseCase: ManageBlockCreatorUseCase
    
    init(userID: String, manageBlockUserUseCase: ManageBlockCreatorUseCase) {
        self.userID = userID
        self.manageBlockUserUseCase = manageBlockUserUseCase
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let didBlockUser = input.didTapBlockUserButton
            .flatMap { _ in
                return self.manageBlockUserUseCase.blockCreator(to: self.userID)
            }
            .asCompletable()
        
        return Output(didBlockUser: didBlockUser)
    }
}
