//
//  GroceryPlan.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

import Foundation

struct GroceryPlan {
    let week: String
    let startDate: String
    let endDate: String
    let shopping: [ShoppingCategory]
    let totalEstimatedPrice: String

    func toEntity() -> GroceryPlanEntity {
        return GroceryPlanEntity(
            week: week,
            startDate: startDate,
            endDate: endDate,
            shopping: shopping.map { $0.toEntity() },
            totalEstimatedPrice: totalEstimatedPrice
        )
    }
}

struct GroceryItem {
    let name: String
    let qty: String
    let estimatedPrice: String

    func toEntity() -> GroceryItemEntity {
        return GroceryItemEntity(
            name: name,
            qty: qty,
            estimatedPrice: estimatedPrice
        )
    }
}
