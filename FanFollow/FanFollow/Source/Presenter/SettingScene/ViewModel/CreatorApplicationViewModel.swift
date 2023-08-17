//
//  CreatorApplicationViewModel.swift
//  FanFollow
//
//  Created by junho lee on 2023/07/31.
//

import RxRelay
import RxSwift

final class CreatorApplicationViewModel: ViewModel {
    struct Input {
        var nextButtonTap: Observable<(Int, [String], String)>
    }

    struct Output {
        var updateResult: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    private let informationUseCase: UpdateUserInformationUseCase
    private let userID: String

    init(informationUseCase: UpdateUserInformationUseCase, userID: String) {
        self.informationUseCase = informationUseCase
        self.userID = userID
    }

    func transform(input: Input) -> Output {
        let result = input.nextButtonTap
            .flatMapLatest {
                return self.informationUseCase.updateUserInformation(
                    updateInformation: $0
                )
            }

        return Output(updateResult: result)
    }
}

