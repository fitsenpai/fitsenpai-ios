//
//  ShoppingCategory.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

import Foundation

struct ShoppingCategory {
    let category: String
    let items: [GroceryItem]
    let totalEstimatedPrice: String

    func toEntity() -> ShoppingCategoryEntity {
        return ShoppingCategoryEntity(
            category: category,
            items: items.map { $0.toEntity() },
            totalEstimatedPrice: totalEstimatedPrice
        )
    }
}
