//
//  GroceryItemDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation

struct GroceryItemDTO: Decodable {
    let name: String?
    let qty: String?
    let estimatedPrice: String?

    func toDomain() -> GroceryItem {
        return GroceryItem(
            name: name ?? "",
            qty: qty ?? "",
            estimatedPrice: estimatedPrice ?? ""
        )
    }
}
