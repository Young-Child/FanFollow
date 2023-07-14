//
//  FetchUserInformationUseCaseTests.swift
//  UseCaseTests
//
//  Created by junho lee on 2023/07/14.
//

import XCTest
import RxSwift

@testable import FanFollow

final class FetchUserInformationUseCaseTests: XCTestCase {
    private var sut: DefaultFetchUserInformationUseCase!
    private var userInformationRepository: StubUserInformationRepository!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        userInformationRepository = StubUserInformationRepository()
        sut = DefaultFetchUserInformationUseCase(userInformationRepository: userInformationRepository)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        userInformationRepository = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    /// 정상적인 조건에서 fetchUserInformation가 제대로 동작하는 지 테스트
    func test_fetchUserInformationInNormalCondition() {
        // given
        userInformationRepository.userInformation = TestData.userInformation
        userInformationRepository.error = nil
        let userID = TestData.userID

        // when
        let observable = sut.fetchUserInformation(for: userID)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value.id, userID)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 fetchUserInformation가 에러를 반환하는 지 테스트
    func test_fetchUserInformationInErrorCondition() {
        // given
        userInformationRepository.userInformation = TestData.userInformation
        userInformationRepository.error = TestData.error
        let userID = TestData.userID

        // when
        let observable = sut.fetchUserInformation(for: userID)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_fetchUserInformationInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, TestData.error)
        })
        .disposed(by: disposeBag)
    }
}

extension FetchUserInformationUseCaseTests {
    private enum TestData {
        static let userInformation = UserInformationDTO(
            userID: "a0728b90-0172-4552-9b31-1f3cab84900b",
            nickName: "하나",
            profilePath: nil,
            jobCategory: nil,
            links: nil,
            introduce: nil,
            isCreator: false,
            createdAt: "2023-07-05 10:25:45.474385+00"
        )
        static let userID = "a0728b90-0172-4552-9b31-1f3cab84900b"
        static let error = NetworkError.unknown
    }
}
