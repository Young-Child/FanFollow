//
//  SearchCreatorUseCaseTests.swift
//  UseCaseTests
//
//  Created by parkhyo on 2023/07/15.
//

import XCTest

import RxSwift
import RxTest
import RxBlocking

@testable import FanFollow

final class SearchCreatorUseCaseTests: XCTestCase {
    private var searchUseCase: SearchCreatorUseCase!
    private var userInformationRepository: StubUserInformationRepository!
    private var error: Error!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        userInformationRepository = StubUserInformationRepository()
        searchUseCase = DefaultSearchCreatorUseCase(userInformationRepository: userInformationRepository)
    }
    
    override func tearDownWithError() throws {
        error = nil
        userInformationRepository = nil
        searchUseCase = nil
        try super.tearDownWithError()
    }
    
    ////  오류가 발생 안했을 경우, 정상값을 반환하는지 확인하는 테스트
    func test_FetchSearchCreatorsIsCorrectWhenSendCorrectData() throws {
        // given
        userInformationRepository.error = nil
        userInformationRepository.userInformations = UserInformationDTO.stubCreatorsData()
        let testText = "Kyo"
        
        // when
        let searchCreatorObservable = searchUseCase.fetchSearchCreators(text: testText, startRange: 0, endRange: 2)
        
        // then
        let result = searchCreatorObservable.toBlocking()
        
        switch result.materialize() {
        case .completed:
            XCTAssertTrue(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "We expected Completed Event, But Occur Error Event")
        }
    }
    
    
    //// 오류 발생 시 오류를 반환하는지 확인하는 테스트
    func test_FetchSearchCreatorsIsErrorWhenSendCorrectData() {
        // given
        userInformationRepository.error = NetworkError.unknown
        userInformationRepository.userInformations = UserInformationDTO.stubCreatorsData()
        let testText = "Kyo"
        
        // when
        let searchCreatorObservable = searchUseCase.fetchSearchCreators(text: testText, startRange: 0, endRange: 2)
        
        // then
        let result = searchCreatorObservable.toBlocking()
        
        switch result.materialize() {
        case .completed:
            XCTAssertThrowsError(NetworkError.unknown, "We expected Error Event, But Occur OnCompleted Event")
        case .failed:
            XCTAssertTrue(true)
        }
    }
}

private extension UserInformationDTO {
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
            )
        ]
    }
}
