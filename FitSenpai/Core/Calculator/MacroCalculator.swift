//
//  MacroCalculator.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/14/25.
//

import Foundation

struct MacroCalculator {
    enum Gender {
        case male
        case female
        case other
    }
    
    enum ActivityLevel {
        case sedentary
        case light
        case moderate
        case heavy
        case athlete
        
        var multiplier: Double {
            switch self {
            case .sedentary: return 1.2
            case .light: return 1.375
            case .moderate: return 1.55
            case .heavy: return 1.725
            case .athlete: return 1.9
            }
        }
    }
    
    enum FitnessGoal {
        case fatLoss
        case muscleGain
        case generalFitness
        case endurance
        case aesthetic
        
        var calorieMultiplier: Double {
            switch self {
            case .fatLoss: return 0.85 // 15% deficit
            case .muscleGain: return 1.10 // 10% surplus
            case .aesthetic: return 0.95 // Mild deficit
            case .endurance: return 1.05 // Slight surplus
            case .generalFitness: return 1.0 // Maintenance
            }
        }
        
        var macroSplit: (protein: Double, fat: Double, carbs: Double) {
            switch self {
            case .fatLoss:
                return (0.40, 0.30, 0.30) // 40/30/30
            case .muscleGain:
                return (0.30, 0.25, 0.45) // 30/25/45
            case .aesthetic:
                return (0.35, 0.25, 0.40) // 35/25/40
            case .endurance:
                return (0.25, 0.25, 0.50) // 25/25/50
            case .generalFitness:
                return (0.30, 0.30, 0.40) // 30/30/40
            }
        }
    }
    
    struct MacroBreakdown {
        let calories: Int
        let protein: Int
        let fat: Int
        let carbs: Int
    }
    
    // MARK: - Properties
    private let height: Double // in cm
    private let weight: Double // in kg
    private let age: Int
    private let gender: Gender
    private let activityLevel: ActivityLevel
    private let goal: FitnessGoal
    
    // MARK: - Initialization
    init(
        height: Double,
        weight: Double,
        age: Int,
        gender: Gender,
        activityLevel: ActivityLevel,
        goal: FitnessGoal,
        isMetric: Bool = true
    ) {
        // Convert to metric if needed
        self.height = isMetric ? height : height * 2.54
        self.weight = isMetric ? weight : weight * 0.453592
        self.age = age
        self.gender = gender
        self.activityLevel = activityLevel
        self.goal = goal
    }
    
    // MARK: - Public Methods
    func calculateMacros() -> MacroBreakdown {
        let bmr = calculateBMR()
        let tdee = calculateTDEE(bmr: bmr)
        let adjustedTDEE = adjustTDEEForGoal(tdee: tdee)
        return calculateMacroSplit(calories: adjustedTDEE)
    }
    
    // MARK: - Private Methods
    private func calculateBMR() -> Double {
        let baseCalculation = (10 * weight) + (6.25 * height) - (5 * Double(age))
        
        switch gender {
        case .male:
            return baseCalculation + 5
        case .female:
            return baseCalculation - 161
        case .other:
            return baseCalculation - 78
        }
    }
    
    private func calculateTDEE(bmr: Double) -> Double {
        return bmr * activityLevel.multiplier
    }
    
    private func adjustTDEEForGoal(tdee: Double) -> Double {
        return tdee * goal.calorieMultiplier
    }
    
    private func calculateMacroSplit(calories: Double) -> MacroBreakdown {
        let roundedCalories = Int(round(calories))
        let split = goal.macroSplit
        
        return MacroBreakdown(
            calories: roundedCalories,
            protein: Int(round(calories * split.protein / 4)), // 4 calories per gram of protein
            fat: Int(round(calories * split.fat / 9)), // 9 calories per gram of fat
            carbs: Int(round(calories * split.carbs / 4)) // 4 calories per gram of carbs
        )
    }
}
