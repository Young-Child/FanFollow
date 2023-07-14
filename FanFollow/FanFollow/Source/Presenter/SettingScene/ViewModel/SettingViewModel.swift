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
        var isCreator: Observable<Bool>
    }
    
    var disposeBag = DisposeBag()
    private let userInformationUseCase: FetchUserInformationUseCase
    
    init(userInformationUseCase: FetchUserInformationUseCase) {
        self.userInformationUseCase = userInformationUseCase
    }
    
    func transform(input: Input) -> Output {
        let userInformation = input.viewWillAppear
            .flatMapLatest {
                return self.userInformationUseCase.fetchUserInformation(for: "a0728b90-0172-4552-9b31-1f3cab84900b")
            }
        
        let sectionModels = userInformation
            .map { SettingSectionModel.generateDefaultModel(user: $0) }
        
        let isCreator = userInformation.map(\.isCreator)
        
        return Output(
            settingSections: sectionModels,
            isCreator: isCreator
        )
    }
    
}
