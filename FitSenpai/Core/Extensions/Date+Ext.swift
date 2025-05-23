//
//  Date+Ext.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/20/25.
//


import Foundation

extension Date {
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
    
    public func toNSDate() -> NSDate {
        return NSDate(timeIntervalSince1970: timeIntervalSince1970)
    }
    
    public func getDateComponents() -> DateComponents {
        return Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: self)
    }
    
    public func isGreaterThan(_ date: Date) -> Bool {
        return compare(date) == .orderedDescending
    }
    
    public func isLessThan(_ date: Date) -> Bool {
        return compare(date) == .orderedAscending
    }
    
    public func isEqualTo(_ date: Date) -> Bool {
        return compare(date) == .orderedSame
    }
    
    public func toString(WithFormat withFormat: String, timezone: TimeZone? = nil) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = withFormat
        dateFormater.amSymbol = "am"
        dateFormater.pmSymbol = "pm"
        dateFormater.timeZone = timezone ?? .current
        return dateFormater.string(from: self)
    }
    
    public func dateByAdding(years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self)!
    }
    
    public func dateByAdding(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    
    public func dateByAdding(weeks: Int) -> Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self)!
    }
    
    public func dateByAdding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    public func dateByAdding(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
    
    public func dateByAdding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    public func dateByAdding(seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }
    
    public func dateDifferenceFrom(_ date: Date, toDate: Date) -> DateComponents {
        return Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: date, to: toDate)
    }
    
    public func yearsFrom(_ date: Date) -> Int {
        return dateDifferenceFrom(date, toDate: self).year ?? 0
    }
    
    public func monthsFrom(_ date: Date ) -> Int {
        return dateDifferenceFrom(date, toDate: self).month ?? 0
    }
    
    public func weeksFrom(_ date: Date) -> Int{
        return dateDifferenceFrom(date, toDate: self).weekOfYear ?? 0
    }
    
    public func daysFrom(_ date: Date) -> Int {
        return dateDifferenceFrom(date, toDate: self).day ?? 0
    }
    
    public func hoursFrom(_ date: Date) -> Int {
        return dateDifferenceFrom(date, toDate: self).hour ?? 0
    }
    
    public func minutesFrom(_ date: Date) -> Int {
        return dateDifferenceFrom(date, toDate: self).minute ?? 0
    }
    
    public func secondsFrom(_ date: Date) -> Int {
        return dateDifferenceFrom(date, toDate: self).second ?? 0
    }
    
    public func datePassed() -> String {
        let calendar = Calendar.current
        if calendar.compare(Date(), to: self, toGranularity: .day) == .orderedSame {
            return "Today"
        } else if calendar.compare(Date().dateByAdding(days: -1), to: self, toGranularity: .day) == .orderedSame {
            return "Yesterday"
        } else {
            return self.toString(WithFormat: "EEEE, MMM dd yyyy")
        }
    }
}

extension Array {
    func sliced(by dateComponents: Set<Calendar.Component>, for key: KeyPath<Element, Date>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur[keyPath: key])
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}
