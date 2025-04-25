//
//  SessionDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

struct SessionDTO: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let expiresAt: Int
    let refreshToken: String
    let user: UserDTO?
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case tokenType
        case expiresIn
        case expiresAt
        case refreshToken
        case user
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.tokenType = try container.decode(String.self, forKey: .tokenType)
        self.expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        self.expiresAt = try container.decode(Int.self, forKey: .expiresAt)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
        self.user = try? container.decode(UserDTO.self, forKey: .user)
    }
}

extension SessionDTO {
    func toDomain() -> FSSession? {
        return FSSession(fromResponse: self)
    }
}
