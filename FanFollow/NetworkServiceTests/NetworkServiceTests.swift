//
//  NetworkServiceTests.swift
//  NetworkServiceTests
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import XCTest

import RxSwift
import RxTest
import RxBlocking
import RxRelay

@testable import FanFollow

final class NetworkServiceTests: XCTestCase {
    private var disposeBag: DisposeBag!
    private var url: String!
    private var sample: MockData!
    
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        url = "https://qacasllvaxvrtwbkiavx.supabase.co"
        sample = MockData()
    }

    override func tearDownWithError() throws {
        disposeBag = DisposeBag()
        url = nil
        sample = nil
    }
    
    /// 네트워크없이 NetworkService 내부의 data 메서드가 정상적인 데이터를 전달하는지 테스트
    func test_FetchingDataWithDataExistWhenStatusCode200() throws {
        //given
        let stubURLSession = StubURLSession.make(
            url: url,
            mock: sample,
            statusCode: 200
        )
        
        let sut = DefaultNetworkService(session: stubURLSession)
        
        // when
        let fetchResult = sut.data(URLRequest(url: URL(string: self.url)!))
        
        //then
        fetchResult
            .subscribe(onNext: { data in
                let result = try! JSONDecoder().decode(ChatDTO.self, from: data)
                let expected = try! JSONDecoder().decode(ChatDTO.self, from: self.sample.sampleData)
                
                XCTAssertEqual(result.chatID, expected.chatID)
            }, onError: { _ in
                XCTAssertThrowsError("We expected onNext Event, But Sending onError Event")
            })
            .disposed(by: disposeBag)
    }
    
    /// 네트워크없이 NetworkService 내부의 data 메서드가 정상적으로 에러를 전달하는지 테스트
    func test_FetchingDataWithDataExistWhenStatusCodeNot200() throws {
        let stubURLSession = StubURLSession.make(
            url: url,
            mock: sample,
            statusCode: 400
        )
        
        let sut = DefaultNetworkService(session: stubURLSession)
        
        let fetchResult = sut.data(URLRequest(url: URL(string: self.url)!))
        
        fetchResult.subscribe(onNext: { _ in
            XCTAssertThrowsError("We expected onError Event, But Sending onNext Event")
        }, onError: { error in
            let error = error as? NetworkError
            let expected = NetworkError.unknown
            
            XCTAssertEqual(error, expected)
        })
        .disposed(by: disposeBag)
    }
    
    /// 네트워크 없이 NetworkService 내부의 execute 메서드가 정상적인값을 반환하는 것에 대한 테스트
    func test_FetchingDataWithDataNoExistWhenStatusCode200() throws {
        let stubURLSession = StubURLSession.make(
            url: url,
            mock: sample,
            statusCode: 200
        )
        
        let sut = DefaultNetworkService(session: stubURLSession)
        
        let fetchResult = sut.execute(URLRequest(url: URL(string: self.url)!))
        
        fetchResult.subscribe(onCompleted: {
            XCTAssert(true)
        }, onError: { _ in
            XCTAssertThrowsError("We expected onCompleted Event, But Sending onError Event")
        })
        .disposed(by: disposeBag)
    }
    
    /// 네트워크 없이 NetworkService 내부의 execute 메서드가 에러를 정상적으로 반환하는 지에 대한 테스트
    func test_FetchingDataWithDataNoExistWhenStatusCodeNot200() throws {
        let stubURLSession = StubURLSession.make(
            url: url,
            mock: sample,
            statusCode: 400
        )
        
        let sut = DefaultNetworkService(session: stubURLSession)
        
        let fetchResult = sut.execute(URLRequest(url: URL(string: self.url)!))
        
        fetchResult.subscribe(onCompleted: {
            XCTAssertThrowsError("We expected onError Event, But Sending onCompleted Event")
        }, onError: { error in
            let error = error as? NetworkError
            let expected = NetworkError.unknown
            XCTAssertEqual(error, expected)
        })
        .disposed(by: disposeBag)
    }
}
