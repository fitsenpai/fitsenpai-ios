//
//  AppMetadataDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

struct AppMetadataDTO: Decodable {
    let provider: String
    let providers: [String]
}

struct IdentityDTO: Decodable {
    let id: String
    let identityData: IdentityDataDTO?
    let provider: String
    let lastSignInAt: String
    let identityId: String
    let createdAt: String
    let email: String
    let userId: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case provider, id, email
        case identityData
        case lastSignInAt
        case identityId
        case createdAt
        case userId
        case updatedAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.provider = try container.decode(String.self, forKey: .provider)
        self.id = try container.decode(String.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.identityData = try container.decodeIfPresent(IdentityDataDTO.self, forKey: .identityData)
        self.lastSignInAt = try container.decode(String.self, forKey: .lastSignInAt)
        self.identityId = try container.decode(String.self, forKey: .identityId)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
    }
}

struct IdentityDataDTO: Decodable {
    let emailVerified: Bool
    let phoneVerified: Bool
    let sub: String
    let confirmationSentAt: String
    let email: String
    let emailConfirmedAt: String
    let confirmedAt: String
    
    enum CodingKeys: String, CodingKey {
        case sub, email
        case emailVerified
        case phoneVerified
        case confirmationSentAt
        case emailConfirmedAt
        case confirmedAt
    }
}
