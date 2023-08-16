//
//  LogInViewModel.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/11.
//

import Foundation

import RxSwift

final class LogInViewModel: ViewModel {
    struct Input {
        var logInButtonTapped: Observable<String>
    }
    
    struct Output {
        var logInSuccess: Observable<Bool>
    }
    
    var disposeBag = DisposeBag()
    private let signUseCase: AppleSigningUseCase
    
    init(signUseCase: AppleSigningUseCase) {
        self.signUseCase = signUseCase
    }
    
    func transform(input: Input) -> Output {
        let logInResult = input.logInButtonTapped
            .flatMap { token in
                return self.signUseCase.logIn(with: token)
                    .map {
                        return $0.accessToken.isEmpty == false
                    }
            }
        
        return Output(logInSuccess: logInResult)
    }
}
