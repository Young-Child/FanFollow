//
//  UserInformationServiceTests.swift
//  ServiceTests
//
//  Created by junho lee on 2023/07/06.
//

import XCTest
import RxSwift

@testable import FanFollow

final class UserInformationServiceTests: XCTestCase {
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

extension UserInformationServiceTests {
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
                "nick_name": "나미",
                "profile_path": "www.naver.com",
                "job_category": 1,
                "links": [
                    "www.naver.com",
                    "www.google.com"
                ],
                "introduce": "사랑의 몸이 하여도 것이다. 얼음 풀이 능히 별과 사라지지 풀밭에 그들의 우리 위하여서. 몸이 크고 붙잡아 하는 우리 이상의 이는 부패를 때문이다. 그들은 품으며, 사는가 그들에게 앞이 인간의 할지라도 사막이다. 피고, 청춘의 눈이 얼음에 풀밭에 구하기 남는 더운지라 물방아 황금시대다. 얼음이 것은 열락의 꽃이 지혜는 길을 것이다.보라, 쓸쓸하랴? 얼마나 무엇이 하여도 실로 옷을 석가는 끓는 보는 봄바람이다. 꽃이 때까지 영원히 이상을 꽃이 앞이 실현에 있다. 속에 못할 얼음 산야에 방지하는 사막이다. 만물은 청춘의 방지하는 철환하였는가? 착목한는 산야에 인류의 맺어, 이것을 것이다.\n\n피고 뭇 힘차게 봄바람이다. 뭇 청춘에서만 고동을 끓는다. 황금시대의 그들의 유소년에게서 것이다. 살았으며, 주며, 평화스러운 소리다.이것은 수 피다. 인생을 그것을 속에서 이 밥을 그들에게 쓸쓸하랴? 이상 오아이스도 얼음에 바이며, 꾸며 능히 것이다. 시들어 넣는 크고 하는 약동하다. 사는가 굳세게 길을 끓는 사막이다. 그와 같으며, 곧 피다. 풍부하게 바이며, 놀이 할지니, 것이다.\n\n방황하였으며, 열락의 피고 인간은 하는 심장은 아니다. 못하다 피가 무엇을 주며, 이상이 대고, 청춘 수 것이다. 없으면, 장식하는 고동을 끓는 우리의 수 더운지라 얼마나 것이다. 피부가 그들을 구하지 피고, 심장의 새가 운다. 위하여 피는 행복스럽고 그들에게 실현에 눈이 인생을 것이다. 희망의 품에 옷을 가슴에 인생에 부패뿐이다. 남는 길지 이는 것은 아름다우냐? 것은 청춘의 피부가 그것은 뭇 커다란 황금시대다. 없으면, 같이 열락의 피어나는 살 그것을 봄바람이다. 풍부하게 뜨고, 생생하며, 만천하의 우리 듣는다. 끝에 바이며, 인간에 이성은 것이다.",
                "is_creator": true,
                "created_at": "2023-07-04T08:40:02.189472+00:00"
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
