//
//  UserInformationRepositoryTests.swift
//  ServiceTests
//
//  Created by junho lee on 2023/07/06.
//

import XCTest
import RxSwift

@testable import FanFollow

final class UserInformationRepositoryTests: XCTestCase {
    private var sut: DefaultUserInformationRepository!
    private var networkService: StubNetworkService!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkService = StubNetworkService()
        sut = DefaultUserInformationRepository(networkService)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        networkService = nil
        disposeBag = nil
        try super.tearDownWithError()
    }
    
    /// 정상적인 조건에서 fetchCreatorInformations가 제대로 동작하는 지 테스트
    func test_FetchCreatorInformationsInNormalCondition() {
        // given
        networkService.data = TestData.userInformationData
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let jobCategory = TestData.jobCategory
        let nickName = TestData.nickName
        let startRange = TestData.startRange
        let endRange = TestData.endRange
        let userID = TestData.userID
        
        // when
        let observable = sut.fetchCreatorInformations(
            jobCategory: jobCategory,
            nickName: nickName,
            startRange: startRange,
            endRange: endRange
        )
        
        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value.first?.userID, userID)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    /// 에러가 발생하는 조건에서 fetchCreatorInformations가 에러를 반환하는 지 테스트
    func test_FetchCreatorInformationsInErrorCondition() {
        // given
        networkService.data = nil
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let jobCategory = TestData.jobCategory
        let nickName = TestData.nickName
        let startRange = TestData.startRange
        let endRange = TestData.endRange
        
        // when
        let observable = sut.fetchCreatorInformations(
            jobCategory: jobCategory,
            nickName: nickName,
            startRange: startRange,
            endRange: endRange
        )
        
        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_fetchCreatorInformationsInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }
    
    /// 정상적인 조건에서 fetchUserInformation가 제대로 동작하는 지 테스트
    func test_FetchUserInformationInNormalCondition() {
        // given
        networkService.data = TestData.userInformationData
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let userID = TestData.userID
        
        // when
        let observable = sut.fetchUserInformation(for: userID)
        
        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value.userID, userID)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    /// 에러가 발생하는 조건에서 fetchUserInformation가 에러를 반환하는 지 테스트
    func test_FetchUserInformationInErrorCondition() {
        // given
        networkService.data = nil
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let userID = TestData.userID
        
        // when
        let observable = sut.fetchUserInformation(for: userID)
        
        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_fetchUserInformationInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 checkSignUpUser가 제대로 동작하는 지 테스트
    func test_CheckSignUpUserInNormalCondition() {
        // given
        networkService.data = TestData.userInformationData
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let userID = TestData.userID

        // when
        let observable = sut.checkSignUpUser(for: userID)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value, true)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 checkSignUpUser가 에러를 반환하는 지 테스트
    func test_CheckSignUpUserInErrorCondition() {
        // given
        networkService.data = nil
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let userID = TestData.userID

        // when
        let observable = sut.checkSignUpUser(for: userID)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_CheckSignUpUserInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 upsertUserInformation가 제대로 동작하는 지 테스트
    func test_UpsertUserInformationInNormalCondition() {
        // given
        networkService.data = Data()
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let userID = TestData.userID
        let nickName = TestData.nickName
        let isCreator = TestData.isCreator
        let createdAt = TestData.createdAt
        
        // when
        let observable = sut.upsertUserInformation(
            userID: userID,
            nickName: nickName,
            profilePath: nil,
            jobCategory: nil,
            links: nil,
            introduce: nil,
            isCreator: isCreator,
            createdAt: createdAt
        )
        
        // then
        observable.subscribe(onCompleted: {
            XCTAssertTrue(true)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    /// 에러가 발생하는 조건에서 upsertUserInformation가 에러를 반환하는 지 테스트
    func test_UpsertUserInformationInErrorCondition() {
        // given
        networkService.data = nil
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let userID = TestData.userID
        let nickName = TestData.nickName
        let isCreator = TestData.isCreator
        let createdAt = TestData.createdAt
        
        // when
        let observable = sut.upsertUserInformation(
            userID: userID,
            nickName: nickName,
            profilePath: nil,
            jobCategory: nil,
            links: nil,
            introduce: nil,
            isCreator: isCreator,
            createdAt: createdAt
        )
        
        // then
        observable.subscribe(onCompleted: {
            XCTFail("test_upsertUserInformationInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }
    
    /// 정상적인 조건에서 deleteUserInformation가 제대로 동작하는 지 테스트
    func test_DeleteUserInformationInNormalCondition() {
        // given
        networkService.data = Data()
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let userID = TestData.userID
        
        // when
        let observable = sut.deleteUserInformation(userID: userID)
        
        // then
        observable.subscribe(onCompleted: {
            XCTAssertTrue(true)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    /// 에러가 발생하는 조건에서 deleteUserInformation가 에러를 반환하는 지 테스트
    func test_DeleteUserInformationInErrorCondition() {
        // given
        networkService.data = nil
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let userID = TestData.userID
        
        // when
        let observable = sut.deleteUserInformation(userID: userID)
        
        // then
        observable.subscribe(onCompleted: {
            XCTFail("test_deleteUserInformationInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }
}

extension UserInformationRepositoryTests {
    enum TestData {
        static let userID = "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2"
        static let nickName = "나미"
        static let jobCategory = 1
        static let isCreator = true
        static let createdAt = Date()
        static let startRange = 0
        static let endRange = 9
        static let userInformationData = """
        [
            {
                "user_id": "5b260fc8-50ef-4f5b-8315-a19e3c69dfc2",
                "nick_name": "Samantha Bradley",
                "profile_path": null,
                "job_category": 0,
                "links": null,
                "introduce": null,
                "is_creator": true,
                "created_at": "2023-08-01T10:32:41.292886+00:00"
            }
        ]
        """.data(using: .utf8)
        static let normalResponse = HTTPURLResponse(
            url: URL(staticString: "test.com"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        static let errorResponse = HTTPURLResponse(
            url: URL(staticString: "test.com"),
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
    }
}
