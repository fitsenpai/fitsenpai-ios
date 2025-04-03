//
//  UserDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

struct UserDTO: Decodable {
    let id: String
    let aud: String
    let role: String
    let email: String
    let emailConfirmedAt: String?
    let phone: String?
    let confirmedAt: String?
    let lastSignInAt: String?
    let appMetadata: AppMetadataDTO?
    let userMetadata: UserMetadataDTO?
    let identities: [IdentityDTO]?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, aud, role, email, phone
        case emailConfirmedAt
        case confirmedAt
        case lastSignInAt
        case appMetadata
        case userMetadata
        case identities
        case createdAt
        case updatedAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.aud = try container.decode(String.self, forKey: .aud)
        self.role = try container.decode(String.self, forKey: .role)
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.emailConfirmedAt = try? container.decodeIfPresent(String.self, forKey: .emailConfirmedAt)
        self.confirmedAt = try? container.decodeIfPresent(String.self, forKey: .confirmedAt)
        self.lastSignInAt = try? container.decodeIfPresent(String.self, forKey: .lastSignInAt)
        self.appMetadata = try? container.decodeIfPresent(AppMetadataDTO.self, forKey: .appMetadata)
        self.userMetadata = try? container.decodeIfPresent(UserMetadataDTO.self, forKey: .userMetadata)
        self.identities = try? container.decodeIfPresent([IdentityDTO].self, forKey: .identities)
        self.createdAt = try? container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try? container.decode(String.self, forKey: .updatedAt)
    }
}

extension UserDTO {
    func toDomain() -> FSUser? {
        return FSUser(fromResponse: self)
    }
}
