//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Copyright (c) 2023 Minii All rights reserved.

import XCTest

import RxBlocking
import RxSwift
import RxTest

@testable import FanFollow

final class NetworkManagerTests: XCTestCase {
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
    
    /// 네트워크없이 NetworkManager 내부의 response 메서드가 정상적인 데이터를 전달하는지 테스트
    func test_FetchingDataWithDataExistWhenStatusCode200() {
        //given
        let stubURLSession = StubURLSession.make(
            url: url,
            mock: sample,
            statusCode: 200
        )
        
        let sut = NetworkManager(session: stubURLSession)
        
        // when
        let fetchResult = sut.response(URLRequest(url: URL(staticString: self.url)))
        
        //then
        fetchResult.map(\.data)
            .subscribe(onNext: { data in
                let result = try! JSONDecoder().decode(ChatDTO.self, from: data)
                let expected = try! JSONDecoder().decode(ChatDTO.self, from: self.sample.sampleData)
                
                XCTAssertEqual(result.chatID, expected.chatID)
            })
            .disposed(by: disposeBag)
    }
    
    /// 네트워크없이 NetworkManager 내부의 response 메서드가 정상적으로 에러를 전달하는지 테스트
    func test_FetchingDataWithDataExistWhenStatusCodeNot200() {
        let stubURLSession = StubURLSession.make(
            url: url,
            mock: sample,
            statusCode: 400
        )
        
        let sut = NetworkManager(session: stubURLSession)
        
        let fetchResult = sut.response(URLRequest(url: URL(staticString: self.url)))
        
        fetchResult.subscribe(onError: { error in
            let error = error as? NetworkError
            let expected = NetworkError.unknown
            
            XCTAssertEqual(error, expected)
        })
        .disposed(by: disposeBag)
    }
}
