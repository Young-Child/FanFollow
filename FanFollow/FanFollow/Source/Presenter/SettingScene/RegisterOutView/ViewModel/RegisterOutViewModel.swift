//
//  RegisterOutViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/16.
//

import RxSwift

final class RegisterOutViewModel: ViewModel {
    struct Input {
        var withdrawlButtonTapped: Observable<Void>
    }
    
    struct Output {
        var withdrawlResult: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    private let withdrawlUseCase: WithdrawalUseCase
    
    init(withdrawlUseCase: WithdrawalUseCase) {
        self.withdrawlUseCase = withdrawlUseCase
    }
    
    func transform(input: Input) -> Output {
        let withdrawlObservable = input.withdrawlButtonTapped
            .flatMap { _ in
                self.withdrawlUseCase.withdrawal()
                    .andThen(Observable<Void>.just(()))
            }
        
        return Output(withdrawlResult: withdrawlObservable)
    }
}
