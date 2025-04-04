import SwiftUI
import Combine

class BMIDetailViewModel: ObservableObject {
    @Published var bmi: Double
    @Published var bmiCategory: BMICategory
    @Published var healthRisks: [String]
    
    init(bmi: Double) {
        self.bmi = bmi
        self.bmiCategory = Self.calculateBMICategory(bmi)
        self.healthRisks = [
            "High blood pressure",
            "Heart disease",
            "Type 2 diabetes",
            "Certain cancers",
            "Sleep apnea"
        ]
    }
    
    var disclaimerText: String {
        """
        BMI is a general measure of health based on height and weight, but it doesn't distinguish \
        between muscle, fat, or bone mass. Factors like age, sex, and muscle composition can influence \
        results, making BMI less accurate for certain individuals.
        """
    }
    
    var whyBMIMattersText: String {
        """
        A higher BMI is often linked to increased health risks. Being overweight or obese can raise \
        the chances of developing conditions like:
        """
    }
    
    func openSource() {
        // Implement source URL opening logic
        // You can use UIApplication.shared.open() here
    }
    
    private static func calculateBMICategory(_ bmi: Double) -> BMICategory {
        switch bmi {
        case ..<18.5:
            return .underweight
        case 18.5..<25:
            return .normal
        case 25..<30:
            return .overweight
        default:
            return .obese
        }
    }
}