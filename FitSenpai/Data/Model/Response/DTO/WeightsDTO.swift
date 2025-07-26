//
//  BmiDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 7/25/25.
//

import Foundation

struct BmiDTO: Decodable {
    let bmi: Double
    let status: String
    
    func toDomain() -> BMIData {
        return BMIData(
            bmi: bmi,
            status: status
        )
    }
}

struct WeightsDTO: Decodable {
    let weight: Double
    let date: String
    
    func toDomain() -> WeightDataPoint {
        return WeightDataPoint(
            date: date.toDate(format: "yyyy-MM-dd") ?? Date(),
            weight: weight
        )
    }
}
