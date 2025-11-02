//
//  SubscriptionRepository.swift
//  FitSenpai
//
//  Created by Mark Daquis on 10/5/25.
//

import Foundation
import CoreKit

final class SubscriptionRepository: SubscriptionRepositoryProtocol {
    @Inject private var remoteDataSource: SubscriptionDataSourceProtocol
    
    func getSubscription() async throws -> [SubscriptionResponse] {
        try await remoteDataSource.getSubscription()
    }
}
