//
//  WeightsDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/25/25.
//

import Foundation

struct WeightsData: Identifiable {
    let id: String = UUID().uuidString
    let weight: Double
    let date: String
}
