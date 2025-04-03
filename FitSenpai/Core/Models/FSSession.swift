//
//  FSSession.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

class FSSession {
    var accessToken: String?
    var tokenType: String?
    var expiresIn: Int?
    var expiresAt: Int?
    var refreshToken: String?
    var user: FSUser?

    init(fromResponse dto: SessionDTO) {
        self.accessToken = dto.accessToken
        self.tokenType = dto.tokenType
        self.expiresIn = dto.expiresIn
        self.expiresAt = dto.expiresAt
        self.refreshToken = dto.refreshToken
        self.user = FSUser(fromResponse: dto.user)
    }
}
