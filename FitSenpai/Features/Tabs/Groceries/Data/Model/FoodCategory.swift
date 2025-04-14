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
            return "icon_egg"
        case .dairyAndAlternatives:
            return "icon_cheese"
        case .vegetables:
            return "icon_carrot"
        case .oilsAndDressings:
            return "icon_drop"
        case .fruits:
            return "icon_orange"
        case .bakingEssentials:
            return "icon_bread"
        case .miscellaneous:
            return "icon_bag"
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
