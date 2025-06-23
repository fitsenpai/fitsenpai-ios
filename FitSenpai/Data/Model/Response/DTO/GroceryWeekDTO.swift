//
//  GroceryPlanDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation

struct GroceryWeekDTO: Decodable {
    let week: Int?
    let startDate: String?
    let endDate: String?
    let shopping: [ShoppingCategoryDTO]?
    let totalEstimatedPrice: String?

    enum CodingKeys: String, CodingKey {
        case week
        case startDate
        case endDate
        case shopping
        case totalEstimatedPrice
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let intWeek = try? container.decode(Int.self, forKey: .week) {
            self.week = intWeek
        } else if let stringWeek = try? container.decode(String.self, forKey: .week),
                  let intFromString = Int(stringWeek) {
            self.week = intFromString
        } else {
            self.week = nil
        }
        
        self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        self.shopping = try container.decodeIfPresent([ShoppingCategoryDTO].self, forKey: .shopping)
        self.totalEstimatedPrice = try container.decodeIfPresent(String.self, forKey: .totalEstimatedPrice)
    }

    func toDomain() -> GroceryWeek {
        return GroceryWeek(
            week: week.map { String($0) } ?? "",
            startDate: startDate ?? "",
            endDate: endDate ?? "",
            shopping: shopping?.map { $0.toDomain() } ?? [],
            totalEstimatedPrice: totalEstimatedPrice ?? ""
        )
    }
}
