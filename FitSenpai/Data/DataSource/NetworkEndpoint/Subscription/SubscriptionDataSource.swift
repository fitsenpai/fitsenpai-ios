//
//  SubscriptionDataSource.swift
//  FitSenpai
//
//  Created by Codex on 10/13/25.
//

import Foundation
import CoreKit

protocol SubscriptionDataSourceProtocol {
    func getSubscription() async throws -> [SubscriptionResponse]
}

final class SubscriptionDataSource: SubscriptionDataSourceProtocol {
    @Inject(key: "subscription")
    private var networkService: NetworkService<SubscriptionEndpoint>
    
    func getSubscription() async throws -> [SubscriptionResponse] {
        try await networkService.request(.getSubscription)
    }
}
