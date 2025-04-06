//
//  OnboardingNavDestination.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import Foundation

enum OnboardingNavDestination: CaseIterable {
    case signin
    case createPlan
}

enum OnboardingSheets: CaseIterable, Identifiable {
    case success
    
    var id: Int { hashValue }
}
