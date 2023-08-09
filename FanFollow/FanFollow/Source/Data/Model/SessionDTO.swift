//
//  SessionDTO.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/08.
//

import Foundation

struct SessionDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Double
    let user: UserDTO

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case user = "user"
    }

    struct UserDTO: Decodable {
        let id: String
    }
}
