//
//  UserRepository.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/13/25.
//

import Foundation
import CoreKit

final class FeedbackRepository: FeedbackRepositoryProfocol {
    
    // MARK: - Dependencies
    @Inject private var remoteDataSource: FeedbackDataSourceProtocol
    
    func sendFeedback(_ params: FeedbackRequest) async throws {
        return try await remoteDataSource.sendFeedback(params)
    }
}
