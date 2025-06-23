//
//  MacrosDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//


import Foundation

struct MacrosDTO: Decodable {
    let calories: Int?
    let protein: Int?
    let carbs: Int?
    let fat: Int?

    enum CodingKeys: String, CodingKey {
        case calories, protein, carbs, fat
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func decodeIntOrString(forKey key: CodingKeys) throws -> Int? {
            if let intValue = try? container.decodeIfPresent(Int.self, forKey: key) {
                return intValue
            } else if let stringValue = try? container.decodeIfPresent(String.self, forKey: key) {
                return Int(stringValue)
            }
            return nil 
        }
        
        self.calories = try decodeIntOrString(forKey: .calories)
        self.protein = try decodeIntOrString(forKey: .protein)
        self.carbs = try decodeIntOrString(forKey: .carbs)
        self.fat = try decodeIntOrString(forKey: .fat)
    }

    func toDomain() -> Macros {
        return Macros(
            calories: calories ?? 0,
            protein: protein ?? 0,
            carbs: carbs ?? 0,
            fat: fat ?? 0
        )
    }
}
