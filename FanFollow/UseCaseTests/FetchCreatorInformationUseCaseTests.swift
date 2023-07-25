//
//  FetchCreatorInformationUseCaseTests.swift
//  UseCaseTests
//
//  Created by junho lee on 2023/07/14.
//

import XCTest
import RxSwift

@testable import FanFollow

final class FetchCreatorInformationUseCaseTests: XCTestCase {
    private var sut: DefaultFetchCreatorInformationUseCase!
    private var userInformationRepository: StubUserInformationRepository!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        userInformationRepository = StubUserInformationRepository()
        sut = DefaultFetchCreatorInformationUseCase(userInformationRepository: userInformationRepository)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        userInformationRepository = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    /// 정상적인 조건에서 checkPostLiked가 제대로 동작하는 지 테스트
    func test_FetchCreatorInformationInNormalCondition() {
        // given
        userInformationRepository.userInformation = TestData.userInformation
        userInformationRepository.error = nil
        let creatorID = TestData.creatorID

        // when
        let observable = sut.fetchCreatorInformation(for: creatorID)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value.id, creatorID)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 checkPostLiked가 에러를 반환하는 지 테스트
    func test_FetchCreatorInformationInErrorCondition() {
        // given
        userInformationRepository.userInformation = TestData.userInformation
        userInformationRepository.error = TestData.error
        let creatorID = TestData.creatorID

        // when
        let observable = sut.fetchCreatorInformation(for: creatorID)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_FetchCreatorInformationInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, TestData.error)
        })
        .disposed(by: disposeBag)
    }
}

extension FetchCreatorInformationUseCaseTests {
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
        static let creatorID = "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2"
        static let error = NetworkError.unknown
    }
}
