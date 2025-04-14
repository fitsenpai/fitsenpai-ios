//
//  MainViewModel.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import Foundation

// MARK: - ViewModel
final class MainViewModel: ObservableObject {
    
    enum MainTab {
        case workouts, meals, groceries, progress
    }
    
    // MARK: - Properties
    @Published var activeSheet: MainViewSheet?
    @Published var selectedDate: Date = Date()
    @Published var currentWeekStartDate: Date = Date()
    @Published var selectedTab: MainTab = .workouts
    @Published var progressData: [Date: Double] = [:]
    @Published var highlightedDays: Set<Int> = []
    
    // MARK: - Initialization
    init() {  }
    
    func updateCurrentWeekStartDate(to date: Date) {
        triggerHaptics()
    }
    
}
