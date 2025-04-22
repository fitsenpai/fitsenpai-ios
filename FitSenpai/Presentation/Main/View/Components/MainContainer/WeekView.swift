//
//  WeekView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/8/25.
//

import SwiftUI

/// A view that displays a week calendar with progress indicators for specific days
struct WeekView: View {
    // MARK: - Properties
    let weekOffset: Int
    @Binding var selectedDate: Date
    var progressByDate: [Date: Double]
    var highlightedDays: Set<Int> = []
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    // MARK: - Initialization
    init(weekOffset: Int,
         selectedDate: Binding<Date>,
         progressByDate: [Date: Double],
         highlightedDays: Set<Int>) {
        self.weekOffset = weekOffset
        self._selectedDate = selectedDate
        self.highlightedDays = highlightedDays
        self.progressByDate = progressByDate
        let today = Calendar.current.startOfDay(for: Date())
        if selectedDate.wrappedValue == Date.distantPast {
            selectedDate.wrappedValue = today
        }
    }
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .center) {
            ForEach(daysInWeek(), id: \.self) { date in
                dayView(for: date)
                if date != daysInWeek().last {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 10)
        .containerRelativeFrame(.horizontal)
    }
    
    // MARK: - Private Views
    private func dayView(for date: Date) -> some View {
        VStack(spacing: 7) {
            ZStack {
                backgroundCircles(for: date)
                
                if shouldHighlight(date), let progress = getProgress(for: date) {
                    progressCircle(progress: progress)
                }
                
                dayLabel(for: date)
            }
            
            dayNumberLabel(for: date)
        }
        .onTapGesture {
            withAnimation {
                selectedDate = date
            }
        }
    }
    
    private func backgroundCircles(for date: Date) -> some View {
        ZStack {
            Circle()
                .fill(shouldHighlight(date) ? Color.fsAccent : Color.clear)
                .frame(width: 34, height: 34)
            
            Circle()
                .stroke(shouldHighlight(date) ? Color.fsAccent : Color.gray246, lineWidth: 2)
                .frame(width: 34, height: 34)
        }
    }
    
    private func progressCircle(progress: Double) -> some View {
        Circle()
            .trim(from: 0, to: CGFloat(progress))
            .stroke(
                Color.fsPrimary,
                style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(-90))
            .frame(width: 34, height: 34)
    }
    
    private func dayLabel(for date: Date) -> some View {
        FSText(
            text: dayAbbreviation(for: date),
            fontStyle: .body12,
            color: .fsTitle
        )
    }
    
    private func dayNumberLabel(for date: Date) -> some View {
        FSText(
            text: "\(dayNumber(for: date))",
            fontStyle: selectedDate == date ? .bodyBold12 : .body12,
            color: selectedDate == date ? .fsTitle : .gray
        )
        .overlay(alignment: .bottom) {
            if isToday(date) {
                Rectangle()
                    .fill(selectedDate == date ? Color.fsTitle : .gray)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func shouldHighlight(_ date: Date) -> Bool {
        let weekday = calendar.component(.weekday, from: date)
        return highlightedDays.contains(weekday)
    }
    
    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    private func getProgress(for targetDate: Date) -> Double? {
        progressByDate.first { entry in
            calendar.isDate(entry.key, inSameDayAs: targetDate)
        }?.value
    }
    
    private func daysInWeek() -> [Date] {
        guard let startOfWeek = calendar.date(
            byAdding: .day,
            value: weekOffset * 7,
            to: startOfCurrentWeek()
        ) else { return [] }
        
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startOfWeek)
        }
    }
    
    private func startOfCurrentWeek() -> Date {
        let components = calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear],
            from: Date()
        )
        return calendar.date(from: components) ?? Date()
    }
    
    private func dayAbbreviation(for date: Date) -> String {
        let weekday = calendar.component(.weekday, from: date)
        let shortWeekdaySymbols = ["Su", "M", "T", "W", "Th", "F", "S"]
        return shortWeekdaySymbols[weekday - 1]
    }
    
    private func dayNumber(for date: Date) -> Int {
        calendar.component(.day, from: date)
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        // Get today's date
        let today = Date()
        let calendar = Calendar.current
        
        // Create dates for this week
        let monday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let tuesday = calendar.date(byAdding: .day, value: 1, to: monday)!
        let saturday = calendar.date(byAdding: .day, value: 5, to: monday)!
        
        // Create progress data for specific dates
        let progressData: [Date: Double] = [
            monday: 0.3,    // 30% progress
            tuesday: 0.7,   // 70% progress
            saturday: 1.0   // 100% progress
        ]
        
        // Sample usage of WeekView
        WeekView(
            weekOffset: 0,  // Current week
            selectedDate: .constant(today),
            progressByDate: progressData,
            highlightedDays: [2, 3, 7]  // Highlight Monday(2), Tuesday(3), Saturday(7)
        )
    }
}

/*
struct YourMainView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        let progressData: [Date: Double] = [
            // Today with 50% progress
            Date(): 0.5,
            
            // Tomorrow with 30% progress
            Calendar.current.date(byAdding: .day, value: 1, to: Date())!: 0.3,
            
            // Day after tomorrow with 80% progress
            Calendar.current.date(byAdding: .day, value: 2, to: Date())!: 0.8
        ]
        
        WeekView(
            weekOffset: 0,
            selectedDate: $selectedDate,
            progressByDate: progressData,
            highlightedWeekdays: [2, 7]  // Monday and Saturday
        )
    }
}
*/
