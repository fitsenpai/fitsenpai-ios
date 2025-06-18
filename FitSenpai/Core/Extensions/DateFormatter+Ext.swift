//
//  DateFormatter+Ext.swift
//  FitSenpai
//
//  Created by Mark Daquis on 6/18/25.
//

import Foundation

extension DateFormatter {
    static let flexible: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static func parseFlexibleDate(from string: String) -> Date? {
        let formats = [
            "yyyy-MM-dd",
            "M/d/yyyy, h:mm a",
            "M/d/yyyy, h:mm a" // Notice the non-breaking space (U+202F) after the time
        ]
        
        for format in formats {
            flexible.dateFormat = format
            if let date = flexible.date(from: string) {
                return date
            }
        }
        return nil
    }
}
