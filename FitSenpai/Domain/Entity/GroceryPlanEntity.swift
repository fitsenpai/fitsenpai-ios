//
//  GroceryPlanEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//


import Foundation
import SwiftData

@Model class GroceryPlanEntity {
    var week: String
    var startDate: String
    var endDate: String
    var shopping: [ShoppingCategoryEntity]
    var totalEstimatedPrice: String
    
    init(week: String, startDate: String, endDate: String, shopping: [ShoppingCategoryEntity], totalEstimatedPrice: String) {
        self.week = week
        self.startDate = startDate
        self.endDate = endDate
        self.shopping = shopping
        self.totalEstimatedPrice = totalEstimatedPrice
    }

    func toDomain() -> GroceryPlan {
        return GroceryPlan(
            week: week,
            startDate: startDate,
            endDate: endDate,
            shopping: shopping.map { $0.toDomain() },
            totalEstimatedPrice: totalEstimatedPrice
        )
    }
}

@Model class GroceryItemEntity {
    var name: String
    var qty: String
    var estimatedPrice: String
    
    init(name: String, qty: String, estimatedPrice: String) {
        self.name = name
        self.qty = qty
        self.estimatedPrice = estimatedPrice
    }

    func toDomain() -> GroceryItem {
        return GroceryItem(
            name: name,
            qty: qty,
            estimatedPrice: estimatedPrice
        )
    }
}
