//
//  ProfileSettingViewModel.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class ProfileSettingViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
    }
    
    struct Output {
        var nickName: Observable<String>
        var jobCategory: Observable<JobCategory>
        var links: Observable<[String]>
        var introduce: Observable<String>
        var isCreator: Observable<Bool>
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
        return Output()
    }
}
