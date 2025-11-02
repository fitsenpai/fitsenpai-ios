//
//  SubscriptionResponse.swift
//  FitSenpai
//
//  Created by Mark Daquis on 10/5/25.
//

import Foundation

struct SubscriptionResponse: Decodable {
    let id: Int
    let createdAt: String
    let storeId: Int
    let customerId: Int
    let orderId: Int
    let productId: Int
    let variantId: Int
    let productName: String
    let variantName: String
    let userName: String
    let userEmail: String
    let status: String
    let statusFormatted: String
    let cardBrand: String
    let cardLastFour: String
    let pause: String
    let cancelled: String
    let trialEndsAt: String
    let billingAnchor: String
    let urls: String
    let renewsAt: String
    let endsAt: String
    let testMode: Bool
    let updatedAt: String
    let orderItemId: Int
    let profileId: Int
    let userId: String
}
