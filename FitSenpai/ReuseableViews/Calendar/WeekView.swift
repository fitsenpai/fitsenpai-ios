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

    var body: some View {
        HStack(alignment: .center) {
            ForEach(daysInWeek(), id: \.self) { date in
                VStack {
                    FSText(text: dayAbbreviation(for: date), fontStyle: .mona12, color: .fsSubtitleColor)

                    ZStack {
                        Circle()
                            .strokeBorder(Color.gray246, lineWidth: selectedDate == date ? 2 : 1)
                            .background(Circle().fill(selectedDate == date ? Color.deepBlackBackground : Color.clear))
                            .frame(width: 40, height: 40)

                        FSText(text: "\(dayNumber(for: date))", fontStyle: .mona12, color: selectedDate == date ? .white : .fsTitle)
                    }
                    
                    Circle()
                        .fill(Color.fsPrimary)
                        .frame(width: 4, height: 4)
                        .padding(.top, 2)
                        
                }
                .padding(.horizontal, 3)
                .onTapGesture {
                    selectedDate = date
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.top, 8)
        
    }

    private func daysInWeek() -> [Date] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(byAdding: .day, value: weekOffset * 7, to: startOfCurrentWeek()) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    private func startOfCurrentWeek() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return calendar.date(from: components) ?? Date()
    }

    private func dayAbbreviation(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date)
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
