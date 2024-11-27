//
//  FSUser.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import ObjectMapper

class FSUser: Mappable {
    var id: String?
    var appMetadata: [String: Any]?
    var userMetadata: [String: Any]?
    var aud: String?
    var confirmationSentAt: String?
    var recoverySentAt: String?
    var emailChangeSentAt: String?
    var newEmail: String?
    var invitedAt: String?
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
    var identities: [UserIdentity]?
    var factors: [String]?

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
        identities           <- map["identities"]
        factors              <- map["factors"]
    }
}
