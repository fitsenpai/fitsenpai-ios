//
//  GroceryPlanEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//


import Foundation
import SwiftData

@Model class GroceryWeekEntity {
    var startDate: String
    var endDate: String
    var shopping: [ShoppingCategoryEntity]
    var totalEstimatedPrice: String
    var pendingGeneration: Bool
    
    init(startDate: String, endDate: String, shopping: [ShoppingCategoryEntity], totalEstimatedPrice: String, pendingGeneration: Bool = false) {
        self.startDate = startDate
        self.endDate = endDate
        self.shopping = shopping
        self.totalEstimatedPrice = totalEstimatedPrice
        self.pendingGeneration = pendingGeneration
    }

    func toDomain() -> GroceryWeek {
        return GroceryWeek(
            startDate: startDate,
            endDate: endDate,
            shopping: shopping.map { $0.toDomain() },
            totalEstimatedPrice: totalEstimatedPrice,
            pendingGeneration: pendingGeneration
        )
    }
}

@Model class GroceryItemEntity {
    var name: String
    var qty: String
    var estimatedPrice: String
    var isSelected: Bool = false
    
    init(name: String, qty: String, estimatedPrice: String, isSelected: Bool) {
        self.name = name
        self.qty = qty
        self.estimatedPrice = estimatedPrice
        self.isSelected = isSelected
    }

    func toDomain() -> GroceryItem {
        return GroceryItem(
            name: name,
            qty: qty,
            estimatedPrice: estimatedPrice,
            isSelected: isSelected
        )
    }
}
