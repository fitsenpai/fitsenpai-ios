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
    
    enum CodingKeys: CodingKey {
        case weightKg
        case date
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.weight = try container.decode(Double.self, forKey: .weightKg)
        self.date = try container.decode(String.self, forKey: .date)
    }
    
    func toDomain() -> WeightDataPoint {
        return WeightDataPoint(
            date: date.toDate(format: "yyyy-MM-dd") ?? Date(),
            weight: weight
        )
    }
}
