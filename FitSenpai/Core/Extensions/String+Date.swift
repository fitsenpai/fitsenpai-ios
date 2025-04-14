//
//  String+Date.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/3/25.
//

import Foundation

extension String {
    func toDate() -> Date? {
        return DateFormatter.iso8601.date(from: self)
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSX"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
