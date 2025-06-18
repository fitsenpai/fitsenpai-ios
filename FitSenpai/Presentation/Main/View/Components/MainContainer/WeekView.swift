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
    @StateObject private var calendarManager = CalendarDataManager.shared
    let weekOffset: Int
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    // MARK: - Initialization
    init(weekOffset: Int) {
        self.weekOffset = weekOffset
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
                calendarManager.selectedDate = date
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
        return FSText(
            text: "\(dayNumber(for: date))",
            fontStyle: calendar.isDate(calendarManager.selectedDate, inSameDayAs: date) ? .bodyBold12 : .body12,
            color: calendar.isDate(calendarManager.selectedDate, inSameDayAs: date) ? .fsTitle : .gray
        )
        .overlay(alignment: .bottom) {
            if isToday(date) {
                Rectangle()
                    .fill(calendar.isDate(calendarManager.selectedDate, inSameDayAs: date) ? Color.fsTitle : .gray)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func shouldHighlight(_ date: Date) -> Bool {
        let weekday = calendar.component(.weekday, from: date)
        return calendarManager.highlightedDays.contains(weekday)
    }
    
    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    private func getProgress(for targetDate: Date) -> Double? {
        calendarManager.progressData.first { entry in
            calendar.isDate(entry.key, inSameDayAs: targetDate)
        }?.value
    }
    
    private func daysInWeek() -> [Date] {
        return calendarManager.daysInWeek(for: self.weekOffset)
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
