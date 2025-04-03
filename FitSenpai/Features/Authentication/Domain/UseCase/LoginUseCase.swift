//
//  LoginUseCase.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/27/24.
//

import Foundation
import Supabase
import Auth

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) async throws -> Auth.Session
}

class LoginUseCase: LoginUseCaseProtocol {
    private let client: FSClient

    init(client: FSClient) {
        guard let fsClient = FSClient.shared else {
            fatalError("FSClient must be initialized before using LoginUseCase")
        }
        self.client = fsClient
    }

    func execute(email: String, password: String) async throws -> Auth.Session {
        let supabaseClient = client.getClient()
        do {
            let session = try await supabaseClient.auth.signIn(email: email, password: password)
            return session
        } catch {
            throw error
        }
    }
}
