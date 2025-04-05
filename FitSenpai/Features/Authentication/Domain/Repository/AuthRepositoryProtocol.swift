//
//  AuthRepositoryProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

protocol AuthRepositoryProtocol {
    func signIn(email: String, password: String) async throws -> (FSUser, FSSession)
    func signUp(name: String, email: String, password: String) async throws -> (FSUser, FSSession)
    func signInWithApple() async throws -> (FSUser, FSSession)
    func signInWithGoogle() async throws -> (FSUser, FSSession)
    func signOut() async throws
    func sendPasswordResetEmail(to email: String) async throws
    func changePassword(currentPassword: String, newPassword: String) async throws
    func deleteAccount(reason: String) async throws
    func getCurrentSession() async throws -> FSUser
}
