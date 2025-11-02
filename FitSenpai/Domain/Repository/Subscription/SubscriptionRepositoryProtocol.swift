//
//  SubscriptionRepositoryProtocol.swift
//  FitSenpai
//
//  Created by Codex on 10/13/25.
//

import Foundation

protocol SubscriptionRepositoryProtocol {
    func getSubscription() async throws -> [SubscriptionResponse]
}
