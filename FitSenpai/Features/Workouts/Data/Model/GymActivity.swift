//
//  GymActivity.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation

struct GymActivity: Decodable {
    let id: Int64
    let code: String
    let name: String
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case code
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
