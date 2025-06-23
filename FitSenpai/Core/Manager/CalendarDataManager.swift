//
//  CalendarDataManager.swift
//  FitSenpai
//
//  Created by Alex Carmack on 5/25/25.
//

import Foundation
import Combine
import SwiftUI // For Calendar

@MainActor
class CalendarDataManager: ObservableObject {
    static let shared = CalendarDataManager()

    @Published var currentWeekOffset: Int {
        didSet {
            // Clamp the offset
            let minOffset = computedMinimumWeekOffset
            let maxOffset = computedMaximumWeekOffset
            if currentWeekOffset < minOffset {
                currentWeekOffset = minOffset
            } else if currentWeekOffset > maxOffset {
                currentWeekOffset = maxOffset
            }
            updateCurrentWeekStartDate()
        }
    }
    
    @Published var selectedDate: Date
    @Published var currentWeekStartDate: Date
    @Published var progressData: [Date: Double]
    @Published var highlightedDays: Set<Int>
    
    @Published var startDate: Date
    @Published var endDate: Date

    private var calendar: Calendar {
        Calendar.current
    }

    private init() {
        // Default configuration
        self.startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        self.endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        
        self.currentWeekOffset = 0
        self.selectedDate = Date()
        self.currentWeekStartDate = Date() // Will be updated by currentWeekOffset's didSet
        self.progressData = [:]
        self.highlightedDays = []
        
        // Initial update for currentWeekStartDate after all properties are initialized
        // and ensure offset is within initial startDate/endDate bounds
        let initialMinOffset = computedMinimumWeekOffset
        let initialMaxOffset = computedMaximumWeekOffset
        if self.currentWeekOffset < initialMinOffset {
            self.currentWeekOffset = initialMinOffset
        } else if self.currentWeekOffset > initialMaxOffset {
            self.currentWeekOffset = initialMaxOffset
        }
        updateCurrentWeekStartDate()
    }

    func configure(startDate: Date, endDate: Date, initialSelectedDate: Date? = nil, initialWeekOffset: Int? = nil) {
        self.startDate = startDate
        self.endDate = endDate
        
        if let offset = initialWeekOffset {
            self.currentWeekOffset = offset
        } else {
            // Ensure currentWeekOffset is valid with new dates, typically reset to 0 or re-evaluate
             self.currentWeekOffset = 0 // Default to current week if not specified
        }
        
        // Clamp after setting potentially new offset and dates
        let minOffset = computedMinimumWeekOffset
        let maxOffset = computedMaximumWeekOffset
        if self.currentWeekOffset < minOffset {
            self.currentWeekOffset = minOffset
        } else if self.currentWeekOffset > maxOffset {
            self.currentWeekOffset = maxOffset
        }

        self.selectedDate = initialSelectedDate ?? Date()
        updateCurrentWeekStartDate() // Update based on new offset and dates
    }
    
    private func updateCurrentWeekStartDate() {
        let newWeekDays = daysInWeek(for: currentWeekOffset)
        currentWeekStartDate = newWeekDays.first ?? Date()
        
        let currentDayOfWeek = calendar.component(.weekday, from: selectedDate)
        if let newSelectedDate = newWeekDays.first(where: { calendar.component(.weekday, from: $0) == currentDayOfWeek }) {
            selectedDate = newSelectedDate
        } else if let firstDayOfNewWeek = newWeekDays.first {
            // Fallback to first day of the week if same weekday not found
            selectedDate = firstDayOfNewWeek
        }
    }

    // MARK: - Date Calculations
    
    private func startOfCurrentWeek() -> Date {
        // This refers to the start of THE current actual week (today's week)
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return calendar.date(from: components) ?? Date()
    }
    
    func daysInWeek(for offset: Int) -> [Date] {
        guard let startOfWeek = calendar.date(byAdding: .day, value: offset * 7, to: startOfCurrentWeek()) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    var computedMinimumWeekOffset: Int {
        let todayWeekStart = self.startOfCurrentWeek()
        guard let startOfWeekForStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startDate)) else { return 0 }
        return calendar.dateComponents([.weekOfYear], from: todayWeekStart, to: startOfWeekForStartDate).weekOfYear ?? 0
    }

    var computedMaximumWeekOffset: Int {
        let todayWeekStart = self.startOfCurrentWeek()
        guard let startOfWeekForEndDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: endDate)) else {
            return computedMinimumWeekOffset // Ensure max is not less than min
        }
        let offset = calendar.dateComponents([.weekOfYear], from: todayWeekStart, to: startOfWeekForEndDate).weekOfYear ?? 0
        return max(offset, computedMinimumWeekOffset)
    }
}
