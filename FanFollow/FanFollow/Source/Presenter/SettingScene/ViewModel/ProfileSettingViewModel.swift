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
        var didTapUpdate: Observable<(String?, Int, [String]?, String?)>
    }
    
    struct Output {
        var profileURL: Observable<(String, String)>
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
        let user = input.viewWillAppear
            .flatMapLatest { _ in
                return self.fetchUserInformationUseCase.fetchCreatorInformation()
            }
        
        let updateResult = input.didTapUpdate
            .flatMapLatest { updateInformation in
                return self.updateUserInformationUseCase.updateUserInformation(
                    updateInformation: updateInformation
                )
            }
            .asObservable()
        
        let profileInformation = Observable.combineLatest(
            user.map(\.profileURL),
            user.map(\.id)
        )
        
        return Output(
            profileURL: profileInformation.asObservable(),
            nickName: user.map(\.nickName),
            jobCategory: user.map(\.jobCategory),
            links: user.map(\.links),
            introduce: user.map(\.introduce),
            isCreator: user.map(\.isCreator),
            updateResult: updateResult
        )
    }
}
