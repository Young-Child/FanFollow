//
//  ProfileSettingViewModel.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import RxSwift

final class ProfileSettingViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var nickNameChanged: Observable<String>
        var categoryChanged: Observable<Int>
        var linksChanged: Observable<[String]>
        var introduceChanged: Observable<String>
        var didTapUpdate: Observable<(Data?, String?, Int, [String]?, String?)>
    }
    
    struct Output {
        var nickName: Observable<String>
        var jobCategory: Observable<JobCategory?>
        var links: Observable<[String]?>
        var introduce: Observable<String?>
        var isCreator: Observable<Bool>
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
        
        let updateResult = input.didTapUpdate
            .flatMapLatest { updateInformation in
                return self.updateUserInformationUseCase.updateUserInformation(
                    userID: self.userID,
                    updateInformation: updateInformation
                )
            }
            .asObservable()
        
        return Output(
            nickName: user.map(\.nickName),
            jobCategory: user.map(\.jobCategory),
            links: user.map(\.links),
            introduce: user.map(\.introduce),
            isCreator: user.map(\.isCreator),
            updateResult: updateResult
        )
    }
}
