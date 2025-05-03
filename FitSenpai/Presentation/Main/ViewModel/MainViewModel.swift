//
//  MainViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import Foundation
import CoreKit

// MARK: - ViewModel
@MainActor
final class MainViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var activeSheet: MainViewSheet?
    @Published var selectedDate: Date = Date()
    @Published var currentWeekStartDate: Date = Date()
    @Published var selectedTab: MainTab = .workouts
    @Published var progressData: [Date: Double] = [:]
    @Published var highlightedDays: Set<Int> = []
    @Published var currentWeekOffset: Int = 0
   
    
    // MARK: - Initialization
    init() { }
    
    func updateCurrentWeekStartDate(to date: Date) {
        triggerHaptics()
    }
}
