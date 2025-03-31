//
//  FoodCategory.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/12/24.
//

import Foundation

enum FoodCategory: String, CaseIterable {
    case proteins
    case dairyAndAlternatives
    case vegetables
    case oilsAndDressings
    case fruits
    case bakingEssentials
    case miscellaneous

    // Method to return the associated image name
    func imageName() -> String {
        switch self {
        case .proteins:
            return "egg"
        case .dairyAndAlternatives:
            return "cheese"
        case .vegetables:
            return "carrot"
        case .oilsAndDressings:
            return "drop"
        case .fruits:
            return "orange"
        case .bakingEssentials:
            return "bread"
        case .miscellaneous:
            return "bag"
        }
    }

    // Method to return the title for each category
    func title() -> String {
        switch self {
        case .proteins:
            return "Proteins"
        case .dairyAndAlternatives:
            return "Dairy and Alternatives"
        case .vegetables:
            return "Vegetables"
        case .oilsAndDressings:
            return "Oils and Dressings"
        case .fruits:
            return "Fruits"
        case .bakingEssentials:
            return "Baking Essentials"
        case .miscellaneous:
            return "Miscellaneous"
        }
    }
}
