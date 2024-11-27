//
//  UserIdentity.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import ObjectMapper

class UserIdentity: Mappable {
    var id: String?
    var identityId: String?
    var userId: String?
    var identityData: [String: Any]?
    var provider: String?
    var createdAt: Date?
    var lastSignInAt: Date?
    var updatedAt: Date?

    required init?(map: Map) {}

    func mapping(map: Map) {
        id            <- map["id"]
        identityId    <- map["identityId"]
        userId        <- map["userId"]
        identityData  <- map["identityData"]
        provider      <- map["provider"]
        createdAt     <- (map["createdAt"], DateTransform())
        lastSignInAt  <- (map["lastSignInAt"], DateTransform())
        updatedAt     <- (map["updatedAt"], DateTransform())
    }
}
