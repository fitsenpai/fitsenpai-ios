//
//  OnboardingNavDestination.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import Foundation

enum AuthNavDestination: CaseIterable {
    case signin
    case createPlan
}

enum CreateProfileSheets: CaseIterable, Identifiable {
    case success
    
    var id: Int { hashValue }
}
