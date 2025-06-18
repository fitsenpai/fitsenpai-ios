//
//  LoginCallbackResponse.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/6/25.
//

import Foundation

struct AuthCallbackResponse: Decodable {
    let token: String
    let refreshToken: String
}

enum AuthCallbackType: String {
    case google
    case apple
}
