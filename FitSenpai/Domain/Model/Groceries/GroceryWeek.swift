//
//  GroceryPlan.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/5/25.
//

import SwiftUI

struct GroceryWeek {
    let startDate: String
    let endDate: String
    let shopping: [ShoppingCategory]
    let totalEstimatedPrice: String

    func toEntity() -> GroceryWeekEntity {
        return GroceryWeekEntity(
            startDate: startDate,
            endDate: endDate,
            shopping: shopping.map { $0.toEntity() },
            totalEstimatedPrice: totalEstimatedPrice
        )
    }
}

class GroceryItem: Identifiable, ObservableObject {
    let id: String = UUID().uuidString
    let name: String
    let qty: String
    let estimatedPrice: String
    @Published var isSelected: Bool
    
    init(name: String, qty: String, estimatedPrice: String, isSelected: Bool = false) {
        self.name = name
        self.qty = qty
        self.estimatedPrice = estimatedPrice
        self.isSelected = isSelected
    }

    func toEntity() -> GroceryItemEntity {
        return GroceryItemEntity(
            name: name,
            qty: qty,
            estimatedPrice: estimatedPrice,
            isSelected: isSelected
        )
    }
}
