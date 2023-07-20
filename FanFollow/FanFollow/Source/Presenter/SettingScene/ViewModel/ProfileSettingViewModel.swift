//
//  ProfileSettingViewModel.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class ProfileSettingViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var nickNameChanged: Observable<String>
        var categoryChanged: Observable<Int>
        var linksChanged: Observable<[String]>
        var introduceChanged: Observable<String>
    }
    
    struct Output {
        var nickName: Observable<String>
        var jobCategory: Observable<JobCategory?>
        var links: Observable<[String]?>
        var introduce: Observable<String?>
        var isFan: Observable<Bool>
        var updateResult: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    
    private let userID: String
    private let fetchUserInformationUseCase: FetchUserInformationUseCase
    private let updateUserInformationUseCase: UpdateUserInformationUseCase
    
    init(
        userID: String,
        fetchUseCase: FetchUserInformationUseCase,
        updateUseCase: UpdateUserInformationUseCase
    ) {
        self.userID = userID
        self.fetchUserInformationUseCase = fetchUseCase
        self.updateUserInformationUseCase = updateUseCase
    }
    
    func transform(input: Input) -> Output {
        let user = fetchUserInformationUseCase.fetchCreatorInformation(for: self.userID)
        
        let isCreator = user.map(\.isCreator)
        
        let creatorUpdateInformation = isCreator
            .take(while: { $0 })
            .flatMapLatest { _ in
                return Observable.zip(
                    input.nickNameChanged,
                    input.categoryChanged,
                    input.linksChanged,
                    input.introduceChanged
                )
            }
            .flatMapLatest {
                return self.updateUserInformationUseCase.updateUserInformation(
                    userID: self.userID,
                    updateInformation: $0
                )
            }
        
        let userUpdateInformation = isCreator
            .take(while: { $0 == false })
            .flatMapLatest { _ in
                return input.nickNameChanged
            }
            .flatMapLatest { nickName in
                return self.updateUserInformationUseCase.updateUserInformation(
                    userID: self.userID,
                    updateInformation: (nickName, nil, nil, nil)
                )
            }
        
        let updateResult = Observable.merge(
            creatorUpdateInformation,
            userUpdateInformation
        )
        
        return Output(
            nickName: user.map(\.nickName),
            jobCategory: user.map(\.jobCategory),
            links: user.map(\.links),
            introduce: user.map(\.introduce),
            isFan: user.map(\.isCreator).map { $0 == false },
            updateResult: updateResult
        )
    }
}
