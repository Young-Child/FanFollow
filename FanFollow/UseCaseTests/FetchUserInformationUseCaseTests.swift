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

    /// 정상적인 조건에서 fetchUserInformation가 팬 정보를 제대로 가져오는지 테스트
    func test_fetchUserInformationOfFanInNormalCondition() {
        // given
        userInformationRepository.userInformation = TestData.fanInformation
        userInformationRepository.error = nil
        let userID = TestData.fanID

        // when
        let observable = sut.fetchUserInformation(for: userID)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertTrue(value is Fan)
            XCTAssertEqual(value.id, userID)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 fetchUserInformation가 크리에이터 정보를 제대로 가져오는지 테스트
    func test_fetchUserInformationOfCreatorInNormalCondition() {
        // given
        userInformationRepository.userInformation = TestData.creatorInformation
        userInformationRepository.error = nil
        let creatorID = TestData.creatorID

        // when
        let observable = sut.fetchUserInformation(for: creatorID)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertTrue(value is Creator)
            XCTAssertEqual(value.id, creatorID)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 fetchUserInformation가 에러를 반환하는 지 테스트
    func test_fetchUserInformationInErrorCondition() {
        // given
        userInformationRepository.userInformation = TestData.fanInformation
        userInformationRepository.error = TestData.error
        let userID = TestData.fanID

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
        static let fanInformation = UserInformationDTO(
            userID: "a0728b90-0172-4552-9b31-1f3cab84900b",
            nickName: "하나",
            profilePath: nil,
            jobCategory: nil,
            links: nil,
            introduce: nil,
            isCreator: false,
            createdAt: "2023-07-05 10:25:45.474385+00"
        )
        static let creatorInformation = UserInformationDTO(
            userID: "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
            nickName: "나미",
            profilePath: "www.naver.com",
            jobCategory: 1,
            links: ["www.naver.com","www.google.com"],
            introduce: "사랑의 몸이 하여도 것이다.",
            isCreator: true,
            createdAt: "2023-07-04 08:40:02.189472+00"
        )
        static let fanID = "a0728b90-0172-4552-9b31-1f3cab84900b"
        static let creatorID = "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2"
        static let error = NetworkError.unknown
    }
}
