//
//  Session.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import ObjectMapper
import Auth

class Session: Mappable {
    var providerToken: String?
    var providerRefreshToken: String?
    var accessToken: String?
    var tokenType: String?
    var expiresIn: Double?
    var expiresAt: Double?
    var refreshToken: String?
    var weakPassword: Bool?
    var user: User?

    required init?(map: Map) {}

    func mapping(map: Map) {
        providerToken        <- map["providerToken"]
        providerRefreshToken <- map["providerRefreshToken"]
        accessToken          <- map["accessToken"]
        tokenType            <- map["tokenType"]
        expiresIn            <- map["expiresIn"]
        expiresAt            <- map["expiresAt"]
        refreshToken         <- map["refreshToken"]
        weakPassword         <- map["weakPassword"]
        user                 <- map["user"]
    }
}
