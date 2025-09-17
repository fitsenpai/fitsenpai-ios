//
//  SignInResponse.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/24/25.
//

import Foundation

struct AuthMobileResponse: Decodable {
    let url: String
}

enum AuthProvider: String {
    case google
    case apple
}
