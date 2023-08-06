//
//  UploadPostUseCaseTests.swift
//  UseCaseTests
//
//  Created by parkhyo on 2023/08/06.
//

import XCTest

import RxSwift
import RxTest
import RxBlocking

@testable import FanFollow

final class UploadPostUseCaseTests: XCTestCase {
    private var uploadUseCase: UploadPostUseCase!
    private var postRepository: StubPostRepository!
    private var imageRepository: StubImageRepository!
    private var disposeBag = DisposeBag()
    private var error: Error!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        postRepository = StubPostRepository()
        imageRepository = StubImageRepository()
        
        uploadUseCase = DefaultUploadPostUseCase(
            postRepository: postRepository,
            imageRepository: imageRepository
        )
    }
    
    override func tearDownWithError() throws {
        error = nil
        postRepository = nil
        imageRepository = nil
        uploadUseCase = nil
        
        try super.tearDownWithError()
    }
    
    ////  Photo Upload 를 수행할 때 정상적인 상황을 수행하는지에 대한 테스트
    func test_UploadPostIsCorrectWhenSendCorrectPhotoData() throws {
        // given
        let uploadData = Upload(title: "Test", content: "TestContent", imageDatas: [], videoURL: nil)
        postRepository.error = nil
        imageRepository.error = nil
        
        // when
        let uploadResultObservable = uploadUseCase.uploadPost(uploadData, userID: "TestUserID")
        
        // then
        let result = uploadResultObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssertTrue(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "We expected Completed Event, But Occur Error Event")
        }
    }
    
    ////  Photo Upload 를 수행할 때 정상적으로 에러를 반환하는지에 대한 테스트
    func test_UploadPostIsErrorWhenSendErrorPhotoData() throws {
        // given
        let uploadData = Upload(title: "Test", content: "TestContent", imageDatas: [], videoURL: nil)
        postRepository.error = NetworkError.unknown
        imageRepository.error = NetworkError.unknown
        
        // when
        let uploadResultObservable = uploadUseCase.uploadPost(uploadData, userID: "TestUserID")
        
        // then
        let result = uploadResultObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssertThrowsError(error, "We expected Error Event, But Occur Correct Event")
        case .failed:
            XCTAssertTrue(true)
        }
    }

    
    ////  Link Upload 를 수행할 때 정상적인 상황을 수행하는지에 대한 테스트
    func test_UploadPostIsCorrectWhenSendCorrectLinkData() throws {
        // given
        let uploadData = Upload(title: "Test", content: "TestContent", imageDatas: [], videoURL: "www.test.com")
        postRepository.error = nil
        imageRepository.error = nil
        
        // when
        let uploadResultObservable = uploadUseCase.uploadPost(uploadData, userID: "TestUserID")
        
        // then
        let result = uploadResultObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssertTrue(true)
        case .failed(_, let error):
            XCTAssertThrowsError(error, "We expected Completed Event, But Occur Error Event")
        }
    }
    
    ////  Link Upload 를 수행할 때 정상적으로 에러를 반환하는지에 대한 테스트
    func test_UploadPostIsErrorWhenSendErrorLinkData() throws {
        // given
        let uploadData = Upload(title: "Test", content: "TestContent", imageDatas: [], videoURL: "www.test.com")
        postRepository.error = NetworkError.unknown
        imageRepository.error = nil
        
        // when
        let uploadResultObservable = uploadUseCase.uploadPost(uploadData, userID: "TestUserID")
        
        // then
        let result = uploadResultObservable.toBlocking().materialize()
        
        switch result {
        case .completed:
            XCTAssertThrowsError(error, "We expected Error Event, But Occur Correct Event")
        case .failed:
            XCTAssertTrue(true)
        }
    }
}
