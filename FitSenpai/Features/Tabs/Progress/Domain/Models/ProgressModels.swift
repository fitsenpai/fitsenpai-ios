import SwiftUI

enum ProgressTimeframe: String, CaseIterable {
    case ninety
    case sixMonths
    case oneYear
    case allTime
    
    var displayText: String {
        switch self {
        case .ninety: return "90 Days"
        case .sixMonths: return "6 Months"
        case .oneYear: return "1 Year"
        case .allTime: return "All time"
        }
    }
}

enum BMICategory: String {
    case underweight = "Underweight"
    case normal = "Normal"
    case overweight = "Overweight"
    case obese = "Obese"
    
    var color: Color {
        switch self {
        case .underweight: return .blue
        case .normal: return .green
        case .overweight: return .orange
        case .obese: return .red
        }
    }
}

struct WeightDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let weight: Double
}