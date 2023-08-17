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
    private let appleSignUseCase: AppleSigningUseCase
    private let signUpUserUseCase: SignUpUserUseCase
    
    init(appleSignUseCase: AppleSigningUseCase, signUpUserUseCase: SignUpUserUseCase) {
        self.appleSignUseCase = appleSignUseCase
        self.signUpUserUseCase = signUpUserUseCase
    }
    
    func transform(input: Input) -> Output {
        let logInResult = input.logInButtonTapped
            .flatMap { token in
                return self.appleSignUseCase.logIn(with: token)
                    .map {
                        return $0.accessToken.isEmpty == false
                    }
            }
            .flatMap { _ in
                self.signUpUserUseCase.checkSignUp()
            }
            .flatMap { checkResult in
                if checkResult {
                    return Observable<Bool>.just(true)
                }

                let uuidText = UUID().description.map { String($0) }
                let randomNickName = uuidText[0..<7].joined()

                return self.signUpUserUseCase.signUp(nickName: randomNickName)
                    .andThen(Observable<Bool>.just(true))
            }
        
        return Output(logInSuccess: logInResult)
    }
}
