//
//  SettingViewModel.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxDataSources
import RxSwift

final class SettingViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
    }
    
    struct Output {
        var settingSections: Observable<[SettingSectionModel]>
    }
    
    var disposeBag = DisposeBag()
    private let userInformationUseCase: FetchUserInformationUseCase
    
    init(userInformationUseCase: FetchUserInformationUseCase) {
        self.userInformationUseCase = userInformationUseCase
    }
    
    func transform(input: Input) -> Output {
        let sections = input.viewWillAppear
            .map { _ in return SettingSectionModel.defaultModel }
        
        return Output(settingSections: sections)
    }
    
}
