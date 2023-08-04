//
//  ApplyCreatorUseCaseTests.swift
//  UseCaseTests
//
//  Created by junho lee on 2023/07/31.
//

import XCTest
import RxSwift

@testable import FanFollow

final class ApplyCreatorUseCaseTests: XCTestCase {
    private var sut: DefaultApplyCreatorUseCase!
    private var userInformationRepository: StubUserInformationRepository!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        userInformationRepository = StubUserInformationRepository()
        sut = DefaultApplyCreatorUseCase(userInformationRepository: userInformationRepository)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        userInformationRepository = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    /// 정상적인 조건에서 applyCreator가 제대로 동작하는 지 테스트
    func test_ApplyCreatorInNormalCondition() {
        // given
        userInformationRepository.userInformation = TestData.userInformation
        userInformationRepository.error = nil
        let userID = TestData.userID
        let creatorInformation = TestData.creatorInformation

        // when
        let observable = sut.applyCreator(userID: userID, creatorInformation: creatorInformation)

        // then
        observable.subscribe(onCompleted: {
            XCTAssert(true)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 applyCreator가 에러를 반환하는 지 테스트
    func test_ApplyCreatorInErrorCondition() {
        userInformationRepository.userInformation = TestData.userInformation
        userInformationRepository.error = TestData.error
        let userID = TestData.userID
        let creatorInformation = TestData.creatorInformation

        // when
        let observable = sut.applyCreator(userID: userID, creatorInformation: creatorInformation)

        // then
        observable.subscribe(onCompleted: {
            XCTFail("test_ApplyCreatorInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, TestData.error)
        })
        .disposed(by: disposeBag)
    }
}

extension ApplyCreatorUseCaseTests {
    private enum TestData {
        static let userInformation = UserInformationDTO(
            userID: "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
            nickName: "나미",
            profilePath: "www.naver.com",
            jobCategory: 1,
            links: ["www.naver.com","www.google.com"],
            introduce: "사랑의 몸이 하여도 것이다.",
            isCreator: true,
            createdDate: Date()
        )
        static let userID = "5b587434-438c-49d8-ae3c-88bb27a891d4"
        static let creatorInformation = (JobCategory.IT.rawValue, [String](), "")
        static let error = NetworkError.unknown
    }
}
