//
//  DeleteAccountUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/4/25.
//


import Foundation
import CoreKit

protocol DeleteAccountUseCaseProtocol {
    func execute(feedback: String) async throws
}

final class DeleteAccountUseCase: DeleteAccountUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: AuthRepositoryProtocol
    
    func execute(feedback: String) async throws  {
        return try await repository.deleteAccount(feedback: feedback)
    }
}
