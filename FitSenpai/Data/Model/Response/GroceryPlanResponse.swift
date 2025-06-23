//
//  GroceryPlanResponse.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//


import Foundation

struct GroceryPlanResponse: Decodable {
    let id: Int
    let plan: [GroceryWeekDTO]
    let createdAt: String?
    let updatedAt: String?
    let userId: String?
    let profileId: String?
}
