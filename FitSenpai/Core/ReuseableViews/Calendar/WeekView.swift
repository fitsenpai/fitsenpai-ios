//
//  WeekView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/22/24.
//

import SwiftUI

struct WeekView: View {
    let weekOffset: Int
    @Binding var selectedDate: Date
    private var calendar: Calendar {
        Calendar.current
    }
    
    // Initialize with today's date if needed
    init(weekOffset: Int, selectedDate: Binding<Date>) {
        self.weekOffset = weekOffset
        self._selectedDate = selectedDate
        
        if selectedDate.wrappedValue == Date.distantPast {
            selectedDate.wrappedValue = Date()
        }
    }

    var body: some View {
        HStack(alignment: .center) {
            ForEach(daysInWeek(), id: \.self) { date in
                VStack(spacing: 7) {
//                    FSText(
//                        text: dayAbbreviation(for: date),
//                        fontStyle: .mona12,
//                        color: .fsSubtitleColor
//                    )

                    ZStack {
                        Circle()
                            .strokeBorder(
                                Color.gray246,
                                lineWidth: selectedDate == date ? 2 : 1
                            )
                            .background(
                                Circle().fill(
                                    Color.fsSecondary
                                )
                            )
                            .frame(width: 40, height: 40)

                        FSText(
                            text: dayAbbreviation(for: date),
                            fontStyle: .mona12Medium,
                            color: .fsTitle
                        )
//                        FSText(
//                            text: "\(dayNumber(for: date))",
//                            fontStyle: .mona12,
//                            color: selectedDate == date ? .white : .fsTitle
//                        )
                    }
                    
                    FSText(
                        text: "\(dayNumber(for: date))",
                        fontStyle: selectedDate == date ? .mona12SemiBold : .mona12Light,
                        color: .fsTitle
                    )
                }
                .padding(.horizontal, 3)
                .onTapGesture {
                    withAnimation {
                        selectedDate = date
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        
    }

    private func daysInWeek() -> [Date] {
        let calendar = Calendar.current
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
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear],
            from: Date()
        )
        return calendar.date(from: components) ?? Date()
    }

    private func dayAbbreviation(for date: Date) -> String {
        let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: date)
            
            // Custom mapping to match your format
            let shortWeekdaySymbols = ["Su", "M", "T", "W", "Th", "F", "S"]
            
            return shortWeekdaySymbols[weekday - 1] // `weekday` is 1-based (Sunday = 1)
    }

    private func dayNumber(for date: Date) -> Int {
        calendar.component(.day, from: date)
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(weekOffset: 1, selectedDate: .constant(Date()))
    }
}
