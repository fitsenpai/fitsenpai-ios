//
//  AuthSuccessResponse.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

struct AuthSuccessResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}

struct EmptyResponse: Decodable {}
