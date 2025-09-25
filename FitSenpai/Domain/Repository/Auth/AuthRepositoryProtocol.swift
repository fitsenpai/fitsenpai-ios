//
//  AuthRepositoryProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

protocol AuthRepositoryProtocol {
    func getUserAuth() async throws -> FSUser
    func signIn(email: String, password: String) async throws -> (FSUser, FSSession)
    func signUp(name: String, email: String, password: String) async throws -> (FSUser, FSSession)
    func signInWithApple(user: String) async throws -> (FSUser, FSSession)
    func signInWithGoogle() async throws -> String
    func getAuthUrl(provider: AuthProvider) async throws -> String 
    func signOut() async throws
    func getAuthCallback(code: String) async throws -> AuthCallbackResponse
    func forgotPasswod(email: String) async throws
    func resetPassword(password: String) async throws
    func verifyOTP(email: String, token: String) async throws
    func deleteAccount(feedback: String) async throws
    func exchangeCode(_ code: String) async throws -> AuthCallbackResponse 
}
