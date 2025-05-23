//
//  ShoppingCategory.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

import Foundation

struct ShoppingCategory: Identifiable {
    var id: String { category } // Computed property for ID
    let category: String
    var items: [GroceryItem]
    let totalEstimatedPrice: String

    // or ensure memberwise initializer still works as expected.
    // Swift should synthesize a memberwise init for category, items, totalEstimatedPrice.
    // If you had a custom init before, ensure it's still valid.
    // For example, if you need to initialize items as empty:
    // init(category: String, items: [GroceryItem] = [], totalEstimatedPrice: String) {
    //     self.category = category
    //     self.items = items
    //     self.totalEstimatedPrice = totalEstimatedPrice
    // }

    func toEntity() -> ShoppingCategoryEntity {
        return ShoppingCategoryEntity(
            category: category,
            items: items.map { $0.toEntity() },
            totalEstimatedPrice: totalEstimatedPrice
        )
    }
}
