//
//  StoredSession.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/08.
//

import Foundation

struct StoredSession {
    let accessToken: String
    let refreshToken: String
    let userID: String
    let expirationDate: Date

    var isValid: Bool {
      expirationDate > Date().addingTimeInterval(60)
    }

    init?(session: SessionDTO?, expirationDate: Date? = nil) {
        guard let session else { return nil }
        self.accessToken = session.accessToken
        self.refreshToken = session.refreshToken
        self.userID = session.user.id
        self.expirationDate = expirationDate ?? Date().addingTimeInterval(session.expiresIn)
    }
}
