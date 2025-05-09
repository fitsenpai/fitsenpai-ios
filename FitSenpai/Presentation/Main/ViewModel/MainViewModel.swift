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
    @Published var selectedTab: MainTab = .workouts
    @Published var activeSheet: MainViewSheet?
    @Published var selectedDate: Date = Date()
    @Published var currentWeekStartDate: Date = Date()
    @Published var progressData: [Date: Double] = [:]
    @Published var highlightedDays: Set<Int> = []
    @Published var currentWeekOffset: Int = 0
   
    private var calendar: Calendar {
        Calendar.current
    }
    
    // MARK: - Initialization
    init() {
        initializeSelectedDate() 
    }
    
    func updateCurrentWeekStartDate(to date: Date) {
        triggerHaptics()
    }
    
    /// Ensures the selected date is within the visible week on initial load
    private func initializeSelectedDate() {
        let today = Date()
        let weekDates = daysInWeek(for: currentWeekOffset)
        
        // Adjust currentWeekOffset so today's date appears in the current week
        if !weekDates.contains(where: { calendar.isDate($0, inSameDayAs: today) }) {
            let currentWeekStart = startOfCurrentWeek()
            let todayStart = calendar.startOfDay(for: today)
            let dayDifference = calendar.dateComponents([.day], from: currentWeekStart, to: todayStart).day ?? 0
            currentWeekOffset = dayDifference / 7
        }
        
        selectedDate = today
    }
    
    private func daysInWeek(for offset: Int = 0) -> [Date] {
        guard let startOfWeek = calendar.date(byAdding: .day, value: offset * 7, to: startOfCurrentWeek()) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    private func startOfCurrentWeek() -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return calendar.date(from: components) ?? Date()
    }
}
