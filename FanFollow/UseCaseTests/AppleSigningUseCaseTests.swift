//
//  AppleSigningUseCaseTests.swift
//  UseCaseTests
//
//  Created by parkhyo on 2023/08/12.
//

import XCTest

import RxSwift
import RxTest
import RxBlocking

@testable import FanFollow

final class AppleSigningUseCaseTests: XCTestCase {
    private var signUseCase: AppleSigningUseCase!
    private var authRepository: StubAuthRepository!
    private var error: Error!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        authRepository = StubAuthRepository()
        signUseCase = DefaultAppleSigningUseCase(authRepository: authRepository)
    }
    
    override func tearDownWithError() throws {
        error = nil
        authRepository = nil
        signUseCase = nil
        try super.tearDownWithError()
    }
    
    //// LogIn 실행시 Repository에서 전달받은 정보를 반환하는지 확인하는 테스트
    func test_LogInIsCorrectWhenSendCorrectData() throws {
        // given
        authRepository.error = nil
        let testToken = "thisistesttoken"
        
        // when
        let logInObservable = signUseCase.logIn(with: testToken)
        
        // then
        let result = logInObservable.toBlocking()
        
        switch result.materialize() {
        case .completed:
            XCTAssertTrue(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "We expected Completed Event, But Occur Error Event")
        }
    }
    
    //// LogIn 실행시 Repository에서 오류를 반환하는지 확인하는 테스트
    func test_LogInIsErrortWhenSendErrorData() throws {
        // given
        authRepository.error = NetworkError.unknown
        let testToken = "thisistesttoken"
        
        // when
        let logInObservable = signUseCase.logIn(with: testToken)
        
        // then
        let result = logInObservable.toBlocking()
        
        switch result.materialize() {
        case .completed:
            XCTAssertThrowsError(NetworkError.unknown, "We expected Error Event, But Occur OnCompleted Event")
        case .failed:
            XCTAssertTrue(true)
        }
    }
}
