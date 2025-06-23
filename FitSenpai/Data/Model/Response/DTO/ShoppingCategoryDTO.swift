//
//  ShoppingCategoryDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation

struct ShoppingCategoryDTO: Decodable {
    let category: String?
    let items: [GroceryItemDTO]?
    let totalEstimatedPrice: String?

    func toDomain() -> ShoppingCategory {
        return ShoppingCategory(
            category: category ?? "",
            items: items?.map { $0.toDomain() } ?? [],
            totalEstimatedPrice: totalEstimatedPrice ?? ""
        )
    }
}
