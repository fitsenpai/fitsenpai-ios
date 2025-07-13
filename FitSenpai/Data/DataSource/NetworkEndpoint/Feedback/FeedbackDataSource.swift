//
//  FeedbackDataSource.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation
import CoreKit

protocol FeedbackDataSourceProtocol {
    func sendFeedback(_ params: FeedbackRequest) async throws
}

final class FeedbackDataSource: FeedbackDataSourceProtocol {
    
    // MARK: - Dependencies
    @Inject(key: "feedback")
    private var networkService: NetworkService<FeedbackEndpoint>
    
    // MARK: - Auth API Calls
    
    func sendFeedback(_ params: FeedbackRequest) async throws {
        return try await networkService.request(.sendFeedback(params))
    }
}
