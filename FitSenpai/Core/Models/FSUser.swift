//
//  FSUser.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import ObjectMapper
import Supabase

class FSUser: Mappable {
    var id: UUID?
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
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        id                   <- map["id"]
        appMetadata          <- map["appMetadata"]
        userMetadata         <- map["userMetadata"]
        aud                  <- map["aud"]
        confirmationSentAt   <- map["confirmationSentAt"]
        recoverySentAt       <- map["recoverySentAt"]
        emailChangeSentAt    <- map["emailChangeSentAt"]
        newEmail             <- map["newEmail"]
        invitedAt            <- map["invitedAt"]
        actionLink           <- map["actionLink"]
        email                <- map["email"]
        phone                <- map["phone"]
        createdAt            <- (map["createdAt"], DateTransform())
        confirmedAt          <- (map["confirmedAt"], DateTransform())
        emailConfirmedAt     <- (map["emailConfirmedAt"], DateTransform())
        phoneConfirmedAt     <- (map["phoneConfirmedAt"], DateTransform())
        lastSignInAt         <- (map["lastSignInAt"], DateTransform())
        role                 <- map["role"]
        updatedAt            <- (map["updatedAt"], DateTransform())
    }
    
    init(fromSupabaseUser user: Supabase.User) {
        self.id = user.id
        self.email = user.email
        self.phone = user.phone
        
        if let appMeta = user.appMetadata as? [AnyJSON: AnyJSON] {
            self.appMetadata = AppMetadata(from: appMeta)
        }
        
        if let userMeta = user.userMetadata as? [AnyJSON: AnyJSON] {
            self.userMetadata = UserMetadata(from: userMeta)
        }
        
        self.aud = user.aud
        self.confirmationSentAt = user.confirmationSentAt
        self.recoverySentAt = user.recoverySentAt
        self.emailChangeSentAt = user.emailChangeSentAt
        self.newEmail = user.newEmail
        self.invitedAt = user.invitedAt
        self.actionLink = user.actionLink
        self.createdAt = user.createdAt
        self.confirmedAt = user.confirmedAt
        self.emailConfirmedAt = user.emailConfirmedAt
        self.phoneConfirmedAt = user.phoneConfirmedAt
        self.lastSignInAt = user.lastSignInAt
        self.role = user.role
        self.updatedAt = user.updatedAt
    }
    
    init?(fromResponse data: UserDTO?) {
        guard let data else { return nil }
        self.id = UUID(uuidString: data.id)
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
        
        init(from metadata: [AnyJSON: AnyJSON]) {
            self.providers = (metadata["providers"]?.value as? [String]) ?? []
            self.provider = (metadata["provider"]?.value as? String) ?? ""
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
    
    struct UserMetadata: Mappable {
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
        
        init(from metadata: [AnyJSON: AnyJSON]) {
            self.emailVerified = (metadata["email_verified"]?.value as? Bool) ?? false
            self.phoneVerified = (metadata["phone_verified"]?.value as? Bool) ?? false
            self.sub = (metadata["sub"]?.value as? String) ?? ""
            self.confirmationSentAt = (metadata["confirmation_sent_at"]?.value as? String) ?? ""
            self.email = (metadata["email"]?.value as? String) ?? ""
            self.emailConfirmedAt = (metadata["email_confirmed_at"]?.value as? String) ?? ""
            self.confirmedAt = (metadata["confirmed_at"]?.value as? String) ?? ""
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
