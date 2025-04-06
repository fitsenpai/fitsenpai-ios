//
//  SubscriptionPlan.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/7/25.
//

import SwiftUI

// MARK: - Models
enum SubscriptionPlan {
    case monthly, annual, lifetime
    
    var pageIndex: Int {
        switch self {
        case .monthly: return 0
        case .annual: return 1
        case .lifetime: return 2
        }
    }
    
    var title: String {
        switch self {
        case .monthly: return "Monthly"
        case .annual: return "Annual"
        case .lifetime: return "Lifetime"
        }
    }
}

struct PlanItem: Identifiable {
    let id = UUID()
    let type: SubscriptionPlan
    let price: String
    let period: String
    let subtitle: String
    let isPopular: Bool
    let originalPrice: String?
    
    init(type: SubscriptionPlan,
         price: String,
         period: String,
         subtitle: String = "",
         isPopular: Bool = false,
         originalPrice: String? = nil) {
        self.type = type
        self.price = price
        self.period = period
        self.subtitle = subtitle
        self.isPopular = isPopular
        self.originalPrice = originalPrice
    }
}

struct SubscriptionPageData {
    let title: String
    let subtitle: String?
    let isPromotional: Bool
    let items: [(String, String, String)]
    
    init(title: String,
         subtitle: String? = nil,
         isPromotional: Bool = false,
         items: [(String, String, String)] = []) {
        self.title = title
        self.subtitle = subtitle
        self.isPromotional = isPromotional
        self.items = items
    }
}
