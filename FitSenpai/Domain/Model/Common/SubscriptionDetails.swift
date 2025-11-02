//
//  SubscriptionDetails.swift
//  FitSenpai
//
//  Created by Mark Daquis on 11/3/25.
//

import SwiftUI

struct SubscriptionDetails: Equatable {
    var isTrial: Bool
    var isActive: Bool
    var startDate: Date?
    var endDate: Date?
    var productId: String?
}
