//
//  CreateProfileUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/29/25.
//


import Foundation
import CoreKit

protocol CreateProfileUseCaseProtocol {
    func execute() async throws
}

final class CreateProfileUseCase: CreateProfileUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: UserRepositoryProtocol

    func execute() async throws  {
        return try await repository.createUserProfile()
    }
}
