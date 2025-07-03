//
//  PasswordViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/4/25.
//

import Foundation
import Combine
import SwiftData
import CoreKit

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var viewState: ViewState = .idle
    
    @Inject private var resetPasswordUseCase: ResetPasswordUseCaseProtocol
    @Inject private var forgotPasswordUseCase: ForgotPasswordUseCaseProtocol
    @Inject private var deleteAccountUseCase: DeleteAccountUseCaseProtocol
    
    func resetPassword(password: String) async throws {
        viewState = .loading
        defer { viewState = .idle }
        try await resetPasswordUseCase.execute(password: password)
    }
    
    func forgotPassword(email: String) async throws {
        viewState = .loading
        defer { viewState = .idle }
        try await forgotPasswordUseCase.execute(email: email)
    }
    
    func deleteAccount(feedback: String) async throws {
        viewState = .loading
        defer { viewState = .idle }
        try await deleteAccountUseCase.execute(feedback: feedback)
    }
}
