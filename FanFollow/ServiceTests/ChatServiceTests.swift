//
//  ChatServiceTests.swift
//  ServiceTests
//
//  Copyright (c) 2023 Minii All rights reserved.

import XCTest

import RxBlocking
import RxTest

@testable import FanFollow

final class ChatServiceTests: XCTestCase {
    private var successResponse: URLResponse!
    private var failureResponse: URLResponse!
    private var networkManager: StubNetworkManager!
    
    override func setUpWithError() throws {
        let url = URL(string: "https://qacasllvaxvrtwbkiavx.supabase.co/rest/v1/CHAT_ROOM?select=chat_id")!
        
        self.successResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        self.failureResponse = HTTPURLResponse(
            url: url,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        let stubNetworkManager = StubNetworkManager(
            data: ChatDTO.data,
            error: nil,
            response: nil
        )
        
        networkManager = stubNetworkManager
    }
    
    override func tearDownWithError() throws {
        successResponse = nil
        failureResponse = nil
        networkManager = nil
    }
}
