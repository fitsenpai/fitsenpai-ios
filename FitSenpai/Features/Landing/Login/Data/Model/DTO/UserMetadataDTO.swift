//
//  UserMetadataDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

struct UserMetadataDTO: Decodable {
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

extension UserMetadataDTO {
    func toDomain() -> FSUser.UserMetadata {
        return FSUser.UserMetadata(
            emailVerified: emailVerified,
            phoneVerified: phoneVerified,
            sub: sub,
            confirmationSentAt: confirmationSentAt,
            email: email,
            emailConfirmedAt: emailConfirmedAt,
            confirmedAt: confirmedAt
        )
    }
}
