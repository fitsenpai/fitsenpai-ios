//
//  SwipeableCalendarView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI


struct SwipeableCalendarView: View {
    @State private var selectedDate = Date() // Tracks the selected date
    @State private var currentWeekOffset = 0 // Tracks the offset for the displayed week
    @State var shouldShowWeekView = true

    var body: some View {
        VStack {
            // Week Range
            HStack(alignment: .center) {
                HStack {
                    Image("ic_calendar")
                        .resizable()
                        .frame(width: 16, height: 16)
                    FSText(text: weekRangeText, fontStyle: .body14, color: .fsSubtitleColor)
                }
                Spacer()
                HStack(spacing: 8) {
                    Button(action: {
                        withAnimation {
                            currentWeekOffset -= 1
                        }
                    }) {
                        Image("ic_left")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Button(action: {
                        withAnimation {
                            currentWeekOffset += 1
                        }
                    }) {
                        Image("ic_right")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            if shouldShowWeekView {
                // Swipeable Weeks
                TabView(selection: $currentWeekOffset) {
                    ForEach(-52...52, id: \.self) { offset in
                        WeekView(weekOffset: offset, selectedDate: $selectedDate)
                            .tag(offset) // Use offset as the tag for swipeable identification
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .frame(height: shouldShowWeekView ? 120 : 30)
    }

    // MARK: - Helper Functions
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    private var weekRangeText: String {
        let weekDates = daysInWeek(for: currentWeekOffset) // Use currentWeekOffset here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = " d"
        
        guard let start = weekDates.first, let end = weekDates.last else { return "" }
        return "\(dateFormatter.string(from: start)) - \(dateFormatter2.string(from: end)), \(calendar.component(.year, from: start))"
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

struct SwipeableCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeableCalendarView()
    }
}
