//
//  DayMealResponse.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/23/25.
//

import Foundation

struct DayMealResponse: Decodable {
    let week: Int
    let startDate: String
    let endDate: String
    let days: [DailyMealPlanDTO]
}
