//
//  LoginResponse.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

struct LoginResponse: Decodable {
    let user: UserDTO?
    let session: SessionDTO?
    
    enum CodingKeys: String, CodingKey {
        case user, session
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user = try? container.decode(UserDTO.self, forKey: .user)
        self.session = try? container.decode(SessionDTO.self, forKey: .session)
    }
}
