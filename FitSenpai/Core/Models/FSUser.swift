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
    var appMetadata: [String: Any]?
    var userMetadata: [String: Any]?
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
        self.appMetadata = user.appMetadata
        self.userMetadata = user.userMetadata
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
    
    init(fromResponse dto: UserDTO) {
        self.id = UUID(uuidString: dto.id)
        self.email = dto.email
        self.phone = dto.phone
        self.role = dto.role
        self.appMetadata = ["provider": dto.appMetadata.provider,
                           "providers": dto.appMetadata.providers]
        self.userMetadata = ["email": dto.userMetadata.email,
                            "email_verified": dto.userMetadata.emailVerified,
                            "phone_verified": dto.userMetadata.phoneVerified,
                            "sub": dto.userMetadata.sub]
        self.aud = dto.aud
        self.emailConfirmedAt = DateFormatter.iso8601.date(from: dto.emailConfirmedAt ?? "")
        self.confirmedAt = DateFormatter.iso8601.date(from: dto.confirmedAt ?? "")
        self.lastSignInAt = DateFormatter.iso8601.date(from: dto.lastSignInAt ?? "")
        self.createdAt = DateFormatter.iso8601.date(from: dto.createdAt)
        self.updatedAt = DateFormatter.iso8601.date(from: dto.updatedAt)
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSX"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
