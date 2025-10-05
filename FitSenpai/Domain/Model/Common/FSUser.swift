//
//  FSUser.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import ObjectMapper

class FSUser {
    var id: UUID
    var appMetadata: AppMetadata?
    var userMetadata: UserMetadata?
    var aud: String?
    var confirmationSentAt: Date?
    var recoverySentAt: Date?
    var emailChangeSentAt: Date?
    var newEmail: String?
    var invitedAt: Date?
    var actionLink: String?
    var email: String?
    var phone: String?
    var createdAt: Date?
    var confirmedAt: Date?
    var emailConfirmedAt: Date?
    var phoneConfirmedAt: Date?
    var lastSignInAt: Date?
    var role: String?
    var updatedAt: Date?
    
    init?(fromResponse data: UserDTO?) {
        guard let data else { return nil }
        self.id = UUID(uuidString: data.id) ?? UUID()
        self.email = data.email
        self.phone = data.phone
        self.role = data.role
        self.aud = data.aud
        self.appMetadata = data.appMetadata?.toDomain()
        self.userMetadata = data.userMetadata?.toDomain()
        self.emailConfirmedAt = data.emailConfirmedAt?.toDate()
        self.confirmedAt = data.confirmedAt?.toDate()
        self.lastSignInAt = data.lastSignInAt?.toDate()
        self.createdAt =  data.createdAt?.toDate()
        self.updatedAt = data.updatedAt?.toDate()
    }
}

extension FSUser {
    struct AppMetadata: Mappable {
        var providers: [String]
        var provider: String
        
        init?(map: Map) {
            self.providers = []
            self.provider = ""
        }
        
        init(providers: [String], provider: String) {
            self.providers = providers
            self.provider = provider
        }
        
        mutating func mapping(map: Map) {
            providers    <- map["providers"]
            provider     <- map["provider"]
        }
    }
    
    struct UserMetadata {
        var emailVerified: Bool
        var phoneVerified: Bool
        var sub: String
        var confirmationSentAt: String
        var email: String
        var emailConfirmedAt: String
        var confirmedAt: String
        
        init?(map: Map) {
            self.emailVerified = false
            self.phoneVerified = false
            self.sub = ""
            self.confirmationSentAt = ""
            self.email = ""
            self.emailConfirmedAt = ""
            self.confirmedAt = ""
        }
        
        init(emailVerified: Bool,
             phoneVerified: Bool,
             sub: String,
             confirmationSentAt: String,
             email: String,
             emailConfirmedAt: String,
             confirmedAt: String) {
            self.emailVerified = emailVerified
            self.phoneVerified = phoneVerified
            self.sub = sub
            self.confirmationSentAt = confirmationSentAt
            self.email = email
            self.emailConfirmedAt = emailConfirmedAt
            self.confirmedAt = confirmedAt
        }
        
        init(from data: UserMetadataDTO) {
            self.emailVerified = data.emailVerified
            self.phoneVerified = data.phoneVerified
            self.sub = data.sub
            self.confirmationSentAt = data.confirmationSentAt
            self.email = data.email
            self.emailConfirmedAt = data.emailConfirmedAt
            self.confirmedAt = data.confirmedAt
        }
        
        mutating func mapping(map: Map) {
            emailVerified        <- map["email_verified"]
            phoneVerified        <- map["phone_verified"]
            sub                  <- map["sub"]
            confirmationSentAt   <- map["confirmation_sent_at"]
            email               <- map["email"]
            emailConfirmedAt    <- map["email_confirmed_at"]
            confirmedAt         <- map["confirmed_at"]
        }
    }
}
