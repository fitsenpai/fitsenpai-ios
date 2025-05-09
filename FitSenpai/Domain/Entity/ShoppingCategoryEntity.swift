//
//  ShoppingCategoryEntity.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/7/25.
//

import SwiftData

@Model class ShoppingCategoryEntity {
    var category: String
    var items: [GroceryItemEntity]
    var totalEstimatedPrice: String
    
    init(category: String, items: [GroceryItemEntity], totalEstimatedPrice: String) {
        self.category = category
        self.items = items
        self.totalEstimatedPrice = totalEstimatedPrice
    }

    func toDomain() -> ShoppingCategory {
        return ShoppingCategory(
            category: category,
            items: items.map { $0.toDomain() },
            totalEstimatedPrice: totalEstimatedPrice
        )
    }
}
