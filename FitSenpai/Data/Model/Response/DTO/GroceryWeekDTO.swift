//
//  GroceryPlanDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation

struct GroceryWeekDTO: Decodable {
    let startDate: String?
    let endDate: String?
    let shopping: [ShoppingCategoryDTO]?
    let totalEstimatedPrice: String?
    let pendingGeneration: Bool?

    enum CodingKeys: String, CodingKey {
        case startDate
        case endDate
        case shopping
        case totalEstimatedPrice
        case pendingGeneration
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        self.shopping = try container.decodeIfPresent([ShoppingCategoryDTO].self, forKey: .shopping)
        self.totalEstimatedPrice = try container.decodeIfPresent(String.self, forKey: .totalEstimatedPrice)
        self.pendingGeneration = try container.decodeIfPresent(Bool.self, forKey: .pendingGeneration) ?? false
    }

    func toDomain() -> GroceryWeek {
        return GroceryWeek(
            startDate: startDate ?? "",
            endDate: endDate ?? "",
            shopping: shopping?.map { $0.toDomain() } ?? [],
            totalEstimatedPrice: totalEstimatedPrice ?? "",
            pendingGeneration: pendingGeneration ?? false
        )
    }
}
