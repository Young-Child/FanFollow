//
//  LogOutViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/16.
//

import RxSwift

final class LogOutViewModel: ViewModel {
    struct Input {
        var logOutButtonTapped: Observable<Void>
    }
    
    struct Output {
        var logOutResult: Observable<Void>
    }
    
    var disposeBag = DisposeBag()
    private let logOutUseCase: LogOutUseCase
    
    init(logOutUseCase: LogOutUseCase) {
        self.logOutUseCase = logOutUseCase
    }
    
    func transform(input: Input) -> Output {
        let logOutObservable = input.logOutButtonTapped
            .flatMap { _ in
                self.logOutUseCase.logOut()
            }
            .asObservable()
            .map { _ in }
        
        return Output(logOutResult: logOutObservable)
    }
}
