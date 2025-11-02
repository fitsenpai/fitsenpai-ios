//
//  GetSubscriptionUseCase.swift
//  FitSenpai
//
//  Created by Codex on 10/13/25.
//

import Foundation
import CoreKit

protocol GetSubscriptionUseCaseProtocol {
    func execute() async throws -> SubscriptionResponse?
}

final class GetSubscriptionUseCase: GetSubscriptionUseCaseProtocol {
    @Inject private var repository: SubscriptionRepositoryProtocol
    
    func execute() async throws -> SubscriptionResponse? {
        try await repository.getSubscription().first
    }
}
