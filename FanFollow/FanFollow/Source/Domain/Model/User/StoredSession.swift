//
//  StoredSession.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/08.
//

import Foundation

struct StoredSession: Codable {
    let accessToken: String
    let refreshToken: String
    let userID: String
    let expirationDate: Date

    var isValid: Bool {
      return expirationDate > Date().addingTimeInterval(86400)
    }

    init?(session: SessionDTO?, expirationDate: Date? = nil) {
        guard let session else { return nil }
        self.accessToken = session.accessToken
        self.refreshToken = session.refreshToken
        self.userID = session.user.id
        self.expirationDate = expirationDate ?? Date().addingTimeInterval(session.expiresIn)
    }
}
