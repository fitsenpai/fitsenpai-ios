//
//  AuthDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

struct AuthResponseDTO: Decodable {
    let schema: AuthSchemaDTO
}

struct AuthSchemaDTO: Decodable {
    let user: UserDTO
    let session: SessionDTO
}

struct UserDTO: Decodable {
    let id: String
    let aud: String
    let role: String
    let email: String
    let emailConfirmedAt: String?
    let phone: String?
    let confirmedAt: String?
    let lastSignInAt: String?
    let appMetadata: AppMetadataDTO
    let userMetadata: UserMetadataDTO
    let identities: [IdentityDTO]
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, aud, role, email, phone
        case emailConfirmedAt = "email_confirmed_at"
        case confirmedAt = "confirmed_at"
        case lastSignInAt = "last_sign_in_at"
        case appMetadata = "app_metadata"
        case userMetadata = "user_metadata"
        case identities
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct AppMetadataDTO: Decodable {
    let provider: String
    let providers: [String]
}

struct UserMetadataDTO: Decodable {
    let email: String
    let emailVerified: Bool
    let phoneVerified: Bool
    let sub: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case emailVerified = "email_verified"
        case phoneVerified = "phone_verified"
        case sub
    }
}

struct IdentityDTO: Decodable {
    let id: String
    let userId: String
    let identityData: IdentityDataDTO
    let provider: String
    let lastSignInAt: String
    let createdAt: String
    let updatedAt: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case identityData = "identity_data"
        case provider
        case lastSignInAt = "last_sign_in_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case email
    }
}

struct IdentityDataDTO: Decodable {
    let email: String
    let emailVerified: Bool
    let phoneVerified: Bool
    let sub: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case emailVerified = "email_verified"
        case phoneVerified = "phone_verified"
        case sub
    }
}

struct SessionDTO: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let expiresAt: Int
    let refreshToken: String
    let user: UserDTO
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case expiresAt = "expires_at"
        case refreshToken = "refresh_token"
        case user
    }
}

// MARK: - Mapping Extensions
extension UserDTO {
    func toDomain() -> FSUser {
        return FSUser(fromResponse: self)
    }
}

extension SessionDTO {
    func toDomain() -> FSSession {
        return FSSession(fromResponse: self)
    }
}
