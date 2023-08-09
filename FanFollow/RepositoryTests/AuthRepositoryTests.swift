//
//  AuthRepositoryTests.swift
//  RepositoryTests
//
//  Created by junho lee on 2023/08/08.
//

import XCTest
import RxSwift

@testable import FanFollow

final class AuthRepositoryTests: XCTestCase {
    private var sut: DefaultAuthRepository!
    private var networkService: StubNetworkService!
    private var userDefaultsService: StubUserDefaultsService!
    private var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        networkService = StubNetworkService()
        userDefaultsService = StubUserDefaultsService()
        sut = DefaultAuthRepository(networkService: networkService, userDefaultsService: userDefaultsService)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        userDefaultsService = nil
        networkService = nil
        disposeBag = nil
        try super.tearDownWithError()
    }

    /// 정상적인 조건에서 signIn이 제대로 동작하는 지 테스트
    func test_SignInInNormalCondition() {
        // given
        networkService.data = TestData.sessionData
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let idToken = TestData.idToken
        let provider = TestData.provider

        // when
        let observable = sut.signIn(with: idToken, of: provider)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value.refreshToken, TestData.refreshToken)
            let userDefaultsData = self.userDefaultsService.data[TestData.session] as? StoredSession
            XCTAssertEqual(userDefaultsData?.refreshToken, TestData.refreshToken)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 signIn이 에러를 반환하는 지 테스트
    func test_SignInInErrorCondition() {
        // given
        networkService.data = TestData.sessionData
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let idToken = TestData.idToken
        let provider = TestData.provider

        // when
        let observable = sut.signIn(with: idToken, of: provider)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_SignInInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 refreshSession이 제대로 동작하는 지 테스트
    func test_RefreshSessionInNormalCondition() {
        // given
        networkService.data = TestData.sessionData
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let refreshToken = TestData.refreshToken

        // when
        let observable = sut.refreshSession(with: refreshToken)

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value.refreshToken, TestData.refreshToken)
            let userDefaultsData = self.userDefaultsService.data[TestData.session] as? StoredSession
            XCTAssertEqual(userDefaultsData?.refreshToken, TestData.refreshToken)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 refreshSession이 에러를 반환하는 지 테스트
    func test_RefreshSessionInErrorCondition() {
        // given
        networkService.data = TestData.sessionData
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let refreshToken = TestData.refreshToken

        // when
        let observable = sut.refreshSession(with: refreshToken)

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_RefreshSessionInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 requestSignOut이 제대로 동작하는 지 테스트
    func test_RequestSignOutInNormalCondition() {
        // given
        networkService.data = TestData.sessionData
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let storedSession = StoredSession(session: TestData.sessionDTO)
        userDefaultsService.data[TestData.session] = storedSession
        let accessToken = TestData.accessToken

        // when
        let observable = sut.signOut(with: accessToken)

        // then
        observable.subscribe(onCompleted: {
            XCTAssertNil(self.userDefaultsService.data[TestData.session])
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)

    }

    /// 에러가 발생하는 조건에서 requestSignOut이 에러를 반환하는 지 테스트
    func test_RequestSignOutInErrorCondition() {
        // given
        networkService.data = TestData.sessionData
        networkService.error = NetworkError.unknown
        networkService.response = TestData.errorResponse
        let accessToken = TestData.accessToken

        // when
        let observable = sut.signOut(with: accessToken)

        // then
        observable.subscribe(onCompleted: {
            XCTFail("test_RequestSignOutInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? NetworkError, .unknown)
        })
        .disposed(by: disposeBag)
    }

    /// 정상적인 조건에서 storedSession이 제대로 동작하는 지 테스트
    func test_StoredSessionInNormalCondition() {
        // given
        let storedSession = StoredSession(session: TestData.sessionDTO)!
        userDefaultsService.data[TestData.session] = storedSession

        // when
        let observable = sut.storedSession()

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value.accessToken, storedSession.accessToken)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 리프레시가 필요한 조건에서 storedSession이 제대로 동작하는 지 테스트
    func test_StoredSessionInConditionRequireRefreshing() {
        // given
        networkService.data = TestData.sessionData
        networkService.error = nil
        networkService.response = TestData.normalResponse
        let storedSession = StoredSession(session: TestData.sessionDTO, expirationDate: Date())!
        userDefaultsService.data[TestData.session] = storedSession

        // when
        let observable = sut.storedSession()

        // then
        observable.subscribe(onNext: { value in
            XCTAssertEqual(value.accessToken, TestData.anotherAccessToken)
        }, onError: { error in
            XCTFail(error.localizedDescription)
        })
        .disposed(by: disposeBag)
    }

    /// 에러가 발생하는 조건에서 storedSession이 에러를 반환하는 지 테스트
    func test_StoredSessionInErrorCondition() {
        // given

        userDefaultsService.data[TestData.session] = nil

        // when
        let observable = sut.storedSession()

        // then
        observable.subscribe(onNext: { _ in
            XCTFail("test_StoredSessionInErrorCondition must occur error event.")
        }, onError: { error in
            XCTAssertEqual(error as? SessionError, .notLoggedIn)
        })
        .disposed(by: disposeBag)
    }
}

extension AuthRepositoryTests {
    enum TestData {
        static let idToken = "eyJraWQiOiJmaDZCczhDIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLnN1cGFiYXNlLmdvdHJ1ZS1zd2lmdC5FeGFtcGxlczEiLCJleHAiOjE2OTE0ODQwMzYsImlhdCI6MTY5MTM5NzYzNiwic3ViIjoiMDAwMTUwLjBjMDE3MjIyMWUzYTRjZWM4YmNiM2E5NDM3Yjc2MDU4LjA3MzEiLCJjX2hhc2giOiJla3g3Qzd6R3A4aWdlckhpdmhZMUpBIiwiZW1haWwiOiJmdHFmaDI0NWMyQHByaXZhdGVyZWxheS5hcHBsZWlkLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjoidHJ1ZSIsImlzX3ByaXZhdGVfZW1haWwiOiJ0cnVlIiwiYXV0aF90aW1lIjoxNjkxMzk3NjM2LCJub25jZV9zdXBwb3J0ZWQiOnRydWV9.jkBB4GYERWmQ1ZrYikQadsNdU3Ui8h6sTHXty_DlgAmcEOCHTxnNVObWzOhU0itaQN7uDcX3gPOXYmzAUMuBA3JHOJo1_AsQCZL7eKE4I3ZBsn5Kfy0d3dQri4ARXm7UzKw0vTtMVPZwYwVSGm9O1lhThtoJfwNE-X8fEPQPsdaCITeQNWamQnDiXejOP-4sAzWQv5xqKqClgWiSe7-lgOPtUpOR4EiGrnpJiYA4OXUWzaxgfT0Dw6QuJYc8UlXobZ53yZz7xt2C52TESOoD2YF59RHsXJv8d5fD2mqOg-7MVskr5kF8twxa62ssTyoVHp2VwHT3z2e_wSqzXacFA"
        static let provider = Provider.apple
        static let refreshToken = "KnHyhkXu3YYrLqlJkYjcXw"
        static let accessToken = "eyJhbGciOiJIUzI1NiIsImtpZCI6InpmTG4vWk1sSlZNVXdXblIiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNjkxNDY0MzU2LCJpYXQiOjE2OTE0NjA3NTYsImlzcyI6Imh0dHBzOi8vcWFjYXNsbHZheHZydHdia2lhdnguc3VwYWJhc2UuY28vYXV0aC92MSIsInN1YiI6IjU1YmMyOTA3LTE2OWYtNDQwYy04N2UxLTBkNDhkYWE4ZjJiYiIsImVtYWlsIjoiZnRxZmgyNDVjMkBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJwaG9uZSI6IiIsImFwcF9tZXRhZGF0YSI6eyJwcm92aWRlciI6ImFwcGxlIiwicHJvdmlkZXJzIjpbImFwcGxlIl19LCJ1c2VyX21ldGFkYXRhIjp7ImN1c3RvbV9jbGFpbXMiOnsiYXV0aF90aW1lIjoxNjkxMzk3NjM2LCJpc19wcml2YXRlX2VtYWlsIjp0cnVlfSwiZW1haWwiOiJmdHFmaDI0NWMyQHByaXZhdGVyZWxheS5hcHBsZWlkLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwicHJvdmlkZXJfaWQiOiIwMDAxNTAuMGMwMTcyMjIxZTNhNGNlYzhiY2IzYTk0MzdiNzYwNTguMDczMSIsInN1YiI6IjAwMDE1MC4wYzAxNzIyMjFlM2E0Y2VjOGJjYjNhOTQzN2I3NjA1OC4wNzMxIn0sInJvbGiOiJhdXRoZW50aWNhdGVkIiwiYWFsIjoiYWFsMSIsImFtciI6W3sibWV0aG9kIjoib2F1dGgiLCJ0aW1lc3RhbXAiOjE2OTE0NjA3NTZ9XSwic2Vzc2lvbl9pZCI6ImQ2MTE1MWEyLTM2OWUtNDhkMS1iMDI0LTU5NGY4MDRhZjAwMSJ9.fBX4vJrYQHzmfcQepuRtJnXDUHKx9T-auqov3hXrBrA"
        static let anotherAccessToken = "eyJhbGciOiJIUzI1NiIsImtpZCI6InpmTG4vWk1sSlZNVXdXblIiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNjkxNDY0MzU2LCJpYXQiOjE2OTE0NjA3NTYsImlzcyI6Imh0dHBzOi8vcWFjYXNsbHZheHZydHdia2lhdnguc3VwYWJhc2UuY28vYXV0aC92MSIsInN1YiI6IjU1YmMyOTA3LTE2OWYtNDQwYy04N2UxLTBkNDhkYWE4ZjJiYiIsImVtYWlsIjoiZnRxZmgyNDVjMkBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJwaG9uZSI6IiIsImFwcF9tZXRhZGF0YSI6eyJwcm92aWRlciI6ImFwcGxlIiwicHJvdmlkZXJzIjpbImFwcGxlIl19LCJ1c2VyX21ldGFkYXRhIjp7ImN1c3RvbV9jbGFpbXMiOnsiYXV0aF90aW1lIjoxNjkxMzk3NjM2LCJpc19wcml2YXRlX2VtYWlsIjp0cnVlfSwiZW1haWwiOiJmdHFmaDI0NWMyQHByaXZhdGVyZWxheS5hcHBsZWlkLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwicHJvdmlkZXJfaWQiOiIwMDAxNTAuMGMwMTcyMjIxZTNhNGNlYzhiY2IzYTk0MzdiNzYwNTguMDczMSIsInN1YiI6IjAwMDE1MC4wYzAxNzIyMjFlM2E0Y2VjOGJjYjNhOTQzN2I3NjA1OC4wNzMxIn0sInJvbGiOiJhdXRoZW50aWNhdGVkIiwiYWFsIjoiYWFsMSIsImFtciI6W3sibWV0aG9kIjoib2F1dGgiLCJ0aW1lc3RhbXAiOjE2OTE0NjA3NTZ9XSwic2Vzc2lvbl9pZCI6ImQ2MTE1MWEyLTM2OWUtNDhkMS1iMDI0LTU5NGY4MDRhZjAwMSJ9.fBX4vJrYQHzmfcQepuRtJnXDUHKx9T-auqov3hXrBrB"
        static let sessionData = """
        {
            "access_token": "eyJhbGciOiJIUzI1NiIsImtpZCI6InpmTG4vWk1sSlZNVXdXblIiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNjkxNDY0MzU2LCJpYXQiOjE2OTE0NjA3NTYsImlzcyI6Imh0dHBzOi8vcWFjYXNsbHZheHZydHdia2lhdnguc3VwYWJhc2UuY28vYXV0aC92MSIsInN1YiI6IjU1YmMyOTA3LTE2OWYtNDQwYy04N2UxLTBkNDhkYWE4ZjJiYiIsImVtYWlsIjoiZnRxZmgyNDVjMkBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJwaG9uZSI6IiIsImFwcF9tZXRhZGF0YSI6eyJwcm92aWRlciI6ImFwcGxlIiwicHJvdmlkZXJzIjpbImFwcGxlIl19LCJ1c2VyX21ldGFkYXRhIjp7ImN1c3RvbV9jbGFpbXMiOnsiYXV0aF90aW1lIjoxNjkxMzk3NjM2LCJpc19wcml2YXRlX2VtYWlsIjp0cnVlfSwiZW1haWwiOiJmdHFmaDI0NWMyQHByaXZhdGVyZWxheS5hcHBsZWlkLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwicHJvdmlkZXJfaWQiOiIwMDAxNTAuMGMwMTcyMjIxZTNhNGNlYzhiY2IzYTk0MzdiNzYwNTguMDczMSIsInN1YiI6IjAwMDE1MC4wYzAxNzIyMjFlM2E0Y2VjOGJjYjNhOTQzN2I3NjA1OC4wNzMxIn0sInJvbGiOiJhdXRoZW50aWNhdGVkIiwiYWFsIjoiYWFsMSIsImFtciI6W3sibWV0aG9kIjoib2F1dGgiLCJ0aW1lc3RhbXAiOjE2OTE0NjA3NTZ9XSwic2Vzc2lvbl9pZCI6ImQ2MTE1MWEyLTM2OWUtNDhkMS1iMDI0LTU5NGY4MDRhZjAwMSJ9.fBX4vJrYQHzmfcQepuRtJnXDUHKx9T-auqov3hXrBrB",
            "token_type": "bearer",
            "expires_in": 3600,
            "refresh_token": "KnHyhkXu3YYrLqlJkYjcXw",
            "user": {
                "id": "55bc2907-169f-440c-87e1-0d48daa8f2bb",
                "aud": "authenticated",
                "role": "authenticated",
                "email": "ftqfh245c2@privaterelay.appleid.com",
                "email_confirmed_at": "2023-08-07T08:35:05.674955Z",
                "phone": "",
                "confirmed_at": "2023-08-07T08:35:05.674955Z",
                "last_sign_in_at": "2023-08-08T02:12:36.886673163Z",
                "app_metadata": {
                    "provider": "apple",
                    "providers": [
                        "apple"
                    ]
                },
                "user_metadata": {
                    "custom_claims": {
                        "auth_time": 1691397636,
                        "is_private_email": true
                    },
                    "email": "ftqfh245c2@privaterelay.appleid.com",
                    "email_verified": true,
                    "iss": "https://appleid.apple.com",
                    "provider_id": "000150.0c0172221e3a4cec8bcb3a9437b76058.0731",
                    "sub": "000150.0c0172221e3a4cec8bcb3a9437b76058.0731"
                },
                "identities": [
                    {
                        "id": "000150.0c0172221e3a4cec8bcb3a9437b76058.0731",
                        "user_id": "55bc2907-169f-440c-87e1-0d48daa8f2bb",
                        "identity_data": {
                            "custom_claims": {
                                "auth_time": 1691460074,
                                "is_private_email": true
                            },
                            "email": "ftqfh245c2@privaterelay.appleid.com",
                            "email_verified": true,
                            "iss": "https://appleid.apple.com",
                            "provider_id": "000150.0c0172221e3a4cec8bcb3a9437b76058.0731",
                            "sub": "000150.0c0172221e3a4cec8bcb3a9437b76058.0731"
                        },
                        "provider": "apple",
                        "last_sign_in_at": "2023-08-07T08:35:05.667371Z",
                        "created_at": "2023-08-07T08:35:05.667422Z",
                        "updated_at": "2023-08-08T02:01:16.914767Z"
                    }
                ],
                "created_at": "2023-08-07T08:35:05.659412Z",
                "updated_at": "2023-08-08T02:12:36.88881Z"
            }
        }
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
        static let session = "session"
        static let userID = "55bc2907-169f-440c-87e1-0d48daa8f2bb"
        static let userDTO = SessionDTO.UserDTO(id: userID)
        static let sessionDTO = SessionDTO(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresIn: 3600,
            user: userDTO
        )
    }
}
