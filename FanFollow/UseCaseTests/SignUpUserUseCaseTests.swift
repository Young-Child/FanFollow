//
//  SignUpUserUseCaseTests.swift
//  UseCaseTests
//
//  Created by junho lee on 2023/08/11.
//

import XCTest
import RxSwift

@testable import FanFollow
final class SignUpUserUseCaseTests: XCTestCase {
    private var sut: DefaultSignUpUserUseCase!
    private var userInformationRepository: StubUserInformationRepository!
    private var authRepository: StubAuthRepository!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        userInformationRepository = StubUserInformationRepository()
        authRepository = StubAuthRepository()
        sut = DefaultSignUpUserUseCase(
            userInformationRepository: userInformationRepository,
            authRepository: authRepository
        )
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        userInformationRepository = nil
        authRepository = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    /// 정상적인 조건에서 checkSignUp가 제대로 동작하는 지 테스트
    func test_CheckSignUpInNormalCondition() {
        // givne
        userInformationRepository.isSignUp = true
        userInformationRepository.error = nil

        // when
        let observable = sut.checkSignUp()

        observable.subscribe(onNext: { result in
            XCTAssertEqual(result, true)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 checkSignUp가 에러를 반환하는 지 테스트
    func test_CheckSignUpInErrorCondition() {
        // givne
        userInformationRepository.error = TestData.error

        // when
        let observable = sut.checkSignUp()

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_CheckSignUpInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, TestData.error)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 signUp가 제대로 동작하는 지 테스트
    func test_SignUpInNormalCondition() {
        // givne
        userInformationRepository.error = nil
        let nickName = TestData.nickName

        // when
        let observable = sut.signUp(nickName: nickName)

        // then
        observable.subscribe(onCompleted: {
            XCTAssert(true)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 signUp가 에러를 반환하는 지 테스트
    func test_SignUpInErrorCondition() {
        // givne
        userInformationRepository.error = TestData.error
        let nickName = TestData.nickName

        // when
        let observable = sut.signUp(nickName: nickName)

        // then
        observable.subscribe(onCompleted: {
            XCTFail("test_SignUpInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, TestData.error)
        })
        .disposed(by: disposeBag)
    }
}

extension SignUpUserUseCaseTests {
    private enum TestData {
        static let nickName = "test"
        static let error = NetworkError.unknown
    }
}
