//
//  WeightsData 2.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/25/25.
//

import Foundation

struct BMIData: Identifiable {
    let id: String = UUID().uuidString
    let bmi: Double
    let status: String
}
