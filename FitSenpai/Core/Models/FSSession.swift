//
//  FSSession.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

class FSSession {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int
    var expiresAt: Int
    var refreshToken: String

    init(fromResponse data: SessionDTO) {
        self.accessToken = data.accessToken
        self.tokenType = data.tokenType
        self.expiresIn = data.expiresIn
        self.expiresAt = data.expiresAt
        self.refreshToken = data.refreshToken
    }
}
