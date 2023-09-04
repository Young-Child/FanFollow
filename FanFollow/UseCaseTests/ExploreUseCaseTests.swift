//
//  ExploreUseCaseTests.swift
//  UseCaseTests
//
//  Created by parkhyo on 2023/07/14.
//

import XCTest

import RxSwift
import RxTest
import RxBlocking

@testable import FanFollow

final class ExploreUseCaseTests: XCTestCase {
    private var exploreUseCase: FetchExploreUseCase!
    private var userInformationRepository: StubUserInformationRepository!
    private var error: Error!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        userInformationRepository = StubUserInformationRepository()
        exploreUseCase = DefaultFetchExploreUseCase(userInformationRepository: userInformationRepository)
    }
    
    override func tearDownWithError() throws {
        error = nil
        userInformationRepository = nil
        exploreUseCase = nil
        try super.tearDownWithError()
    }
    
    ////  RPC를 실행 없이 Repository에서 전달받은 Creator정보를 반환하는지 확인하는 테스트
    func test_FetchRandomCreatorsIsCorrectWhenSendCorrectData() throws {
        // given
        userInformationRepository.error = nil
        userInformationRepository.userInformations = UserInformationDTO.stubCreatorsData()
        
        // when
        let randomCreatorsObservable = exploreUseCase.fetchRandomCreators(by: .IT, count: 3)
        
        // then
        let result = randomCreatorsObservable.toBlocking()
        
        XCTAssertEqual(try? result.first()?.count, 3)
        
        switch result.materialize() {
        case .completed:
            XCTAssertTrue(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "We expected Completed Event, But Occur Error Event")
        }
    }
    
    ////  RPC를 실행 없이 Repository에서 전달받은 카테고리 별 Creator정보를 반환하는지 확인하는 테스트
    func test_FetchRandomAllCreatorsIsCorrectWhenSendCorrectData() throws {
        // given
        userInformationRepository.error = nil
        userInformationRepository.userInformations = UserInformationDTO.stubCreatorsData()
        
        // when
        let randomAllCreatorsObservable = exploreUseCase.fetchRandomCreatorsByAllCategory(count: 10)
        
        // then
        let result = randomAllCreatorsObservable.toBlocking()
        
        XCTAssertEqual(try? result.first()?.count, JobCategory.allCases.count )
        
        switch result.materialize() {
        case .completed:
            XCTAssertTrue(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "We expected Completed Event, But Occur Error Event")
        }
    }
    
    ////  RPC를 실행 없이 Repository에서 전달받은 Popular Creator정보를 반환하는지 확인하는 테스트
    func test_FetchPopularCreatorsIsCorrectWhenSendCorrectData() throws {
        // given
        userInformationRepository.error = nil
        userInformationRepository.userInformations = UserInformationDTO.stubCreatorsData()
        
        // when
        let randomCreatorsObservable = exploreUseCase.fetchPopularCreators(by: .IT, count: 1)
        
        // then
        let result = randomCreatorsObservable.toBlocking()
        
        XCTAssertEqual(try? result.first()?.count, 3)
        
        switch result.materialize() {
        case .completed:
            XCTAssertTrue(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "We expected Completed Event, But Occur Error Event")
        }
    }
    
    func test_FetchCreatorsIsCorrectWhenSendCorrectData() throws {
        // given
        userInformationRepository.error = nil
        userInformationRepository.userInformations = UserInformationDTO.stubCreatorsData()
        
        // when
        let creatorsObservable = exploreUseCase.fetchCreators(by: .IT, startRange: 0, endRange: 2)
        
        //then
        let result = creatorsObservable.toBlocking()
        
        XCTAssertEqual(try? result.first()?.count, 3)
        
        switch result.materialize() {
        case .completed:
            XCTAssertTrue(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "We expected Completed Event, But Occur Error Event")
        }
    }
    
    ////  RPC를 실행 없이 Repository에서 전달받은 에러를 반환하는지 확인하는 테스트
    func test_FetchRandomCreatorsIsErrorWhenSendCorrectData() throws {
        // given
        userInformationRepository.error = NetworkError.unknown
        userInformationRepository.userInformations = UserInformationDTO.stubCreatorsData()
        
        // when
        let randomCreatorsObservable = exploreUseCase.fetchRandomCreators(by: .IT, count: 3)
        
        // then
        let result =  randomCreatorsObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssertThrowsError(NetworkError.unknown, "We expected Error Event, But Occur OnCompleted Event")
        case .failed:
            XCTAssertTrue(true)
        }
    }
}

private extension UserInformationDTO {
    static func stubCreatorData() -> Self {
        return UserInformationDTO(
            userID: "UserTestID",
            nickName: "CreatorTestNickName",
            profilePath: "CreatorTestProfileTest",
            jobCategory: JobCategory.IT.rawValue,
            links: [],
            introduce: "CreatorTestIntroduce",
            isCreator: true,
            createdDate: Date()
        )
    }
    
    static func stubCreatorsData() -> [Self] {
        return [
            UserInformationDTO(
                userID: "UserTestID",
                nickName: "CreatorTestNickName",
                profilePath: "CreatorTestProfileTest",
                jobCategory: JobCategory.IT.rawValue,
                links: [],
                introduce: "CreatorTestIntroduce",
                isCreator: true,
                createdDate: Date()
            ),
            
            UserInformationDTO(
                userID: "UserTestID2",
                nickName: "CreatorTestNickName",
                profilePath: "CreatorTestProfileTest",
                jobCategory: JobCategory.IT.rawValue,
                links: [],
                introduce: "CreatorTestIntroduce",
                isCreator: true,
                createdDate: Date()
            ),
            
            UserInformationDTO(
                userID: "UserTestID3",
                nickName: "CreatorTestNickName",
                profilePath: "CreatorTestProfileTest",
                jobCategory: JobCategory.art.rawValue,
                links: [],
                introduce: "CreatorTestIntroduce",
                isCreator: true,
                createdDate: Date()
            ),
        ]
    }
    
    
    static func stubFanData() -> Self {
        return UserInformationDTO(
            userID: "UserTestID",
            nickName: "FanTestNickName",
            profilePath: "FanTestProfileTest",
            jobCategory: nil,
            links: nil,
            introduce: nil,
            isCreator: false,
            createdDate: Date()
        )
    }
}
