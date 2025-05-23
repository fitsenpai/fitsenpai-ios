//
//  FoodCategory.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/12/24.
//

import SwiftUI

enum FoodCategory: String, CaseIterable {
    case proteins
    case dairyAndAlternatives
    case vegetables
    case oilsAndDressings
    case fruits
    case bakingEssentials
    case miscellaneous
    
    init(rawValue: String) {
        switch rawValue {
        case "Proteins": self = .proteins
        case "Dairy and Alternatives": self = .dairyAndAlternatives
        case "Vegetables": self = .vegetables
        case "Baking Essentials": self = .bakingEssentials
        case "Oils and Dressings": self = .oilsAndDressings
        case "Fruits": self = .fruits
        default: self = .miscellaneous
        }
    }

    // Method to return the associated image name
    var icon: ImageResource {
        switch self {
        case .proteins:
            return .iconEgg
        case .dairyAndAlternatives:
            return .iconCheese
        case .vegetables:
            return .iconCarrot
        case .oilsAndDressings:
            return .iconDrop
        case .fruits:
            return .iconOrange
        case .bakingEssentials:
            return .iconBread
        case .miscellaneous:
            return .icGroceries
        }
    }

    // Method to return the title for each category
    var title: String {
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
