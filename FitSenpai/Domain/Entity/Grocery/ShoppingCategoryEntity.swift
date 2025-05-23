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
        // Map to domain models first
        let domainItems = items.map { $0.toDomain() } // Results in [GroceryItem]
        
        // Then sort the array of domain models
        let sortedDomainItems = domainItems.sorted { $0.name.lowercased() < $1.name.lowercased() }
        
        return ShoppingCategory(
            category: category,
            items: sortedDomainItems, // Pass the sorted array
            totalEstimatedPrice: totalEstimatedPrice
        )
    }
}
