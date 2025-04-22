//
//  SwipeableCalendarView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import SwiftUI


struct SwipeableCalendarView: View {
    @Binding var currentWeekOffset: Int // Tracks the offset for the displayed week
    @State var shouldShowWeekView = true
    @Binding var selectedDate: Date
    @Binding var currentWeekStartDate: Date
    @Binding var progressData: [Date: Double]
    @Binding var highlightedDays: Set<Int>

    var body: some View {
        VStack {
            // Week Range
            HStack(alignment: .center) {
                FSText(text: weekRangeText, fontStyle: .medium14, color: .fsMutedForeground)
                    .padding(.leading, 12)
                
                Spacer()
            }
            
            if shouldShowWeekView {
                // Swipeable Weeks
                TabView(selection: $currentWeekOffset) {
                    ForEach(-52...52, id: \.self) { offset in
                        WeekView(weekOffset: offset, selectedDate: $selectedDate, progressByDate: progressData, highlightedDays: highlightedDays)
                            .tag(offset) // Use offset as the tag for swipeable identification
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .frame(height: shouldShowWeekView ? 90 : 30)
        .padding(.horizontal, 12)
        .onChange(of: currentWeekOffset) { _, _ in
            updateCurrentWeekStartDate()
        }
    }

    // MARK: - Helper Functions
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    private var weekRangeText: String {
        let weekDates = daysInWeek(for: currentWeekOffset) // Use currentWeekOffset here
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM d"
        dateFormatter.dateFormat = "MMMM"
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = " d"
        
        guard let start = weekDates.first, let _ = weekDates.last else { return "" }
        
//        return "\(dateFormatter.string(from: start)) - \(dateFormatter2.string(from: end)), \(calendar.component(.year, from: start))"
        return "\(dateFormatter.string(from: start))"
    }
    
    private func daysInWeek(for offset: Int = 0) -> [Date] {
        guard let startOfWeek = calendar.date(byAdding: .day, value: offset * 7, to: startOfCurrentWeek()) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    private func startOfCurrentWeek() -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return calendar.date(from: components) ?? Date()
    }
    
    private func updateCurrentWeekStartDate() {
            // Calculate the start date of the week for the given offset
        currentWeekStartDate = daysInWeek(for: currentWeekOffset).first ?? Date()
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
}

struct SwipeableCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeableCalendarView(currentWeekOffset: .constant(0), selectedDate: .constant(Date()), currentWeekStartDate: .constant(Date()), progressData: .constant([
            // Today with 50% progress
            Date(): 0.5,
            
            // Tomorrow with 30% progress
            Calendar.current.date(byAdding: .day, value: 2, to: Date())!: 0.3,
            
            // Day after tomorrow with 80% progress
            Calendar.current.date(byAdding: .day, value: 4, to: Date())!: 0.8,
            Calendar.current.date(byAdding: .day, value: 5, to: Date())!: 0.1,
            
            // Tomorrow with 30% progress
            Calendar.current.date(byAdding: .day, value: 6, to: Date())!: 0.3,
            Calendar.current.date(byAdding: .day, value: 7, to: Date())!: 0.7,
            
            // Day after tomorrow with 80% progress
            Calendar.current.date(byAdding: .day, value: 8, to: Date())!: 0.9
        ]), highlightedDays: .constant([1,3,5]))
    }
}
