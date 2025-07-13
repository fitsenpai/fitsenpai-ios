//
//  SendFeedbackUseCaseProtocol.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/13/25.
//



import Foundation
import CoreKit

protocol SendFeedbackUseCaseProtocol {
    func execute(_ params: FeedbackRequest) async throws
}

final class SendFeedbackUseCase: SendFeedbackUseCaseProtocol {
    // MARK: - Dependencies
    @Inject private var repository: FeedbackRepositoryProfocol

    func execute(_ params: FeedbackRequest) async throws {
        return try await repository.sendFeedback(params)
    }
}
