//
//  DateTimeUtils.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/31/22.
//

import Foundation

enum DateTimeUtils {
    
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }
    
    static func localDateFrom(string: String) -> String {
        let date = DateTimeUtils.dateFrom(string: string)
        return shortDateFormatter.string(from: date)
    }
    
    static var shortDateFormatter: DateFormatter {
        let formatter = dateFormatter
        formatter.dateFormat = "MMM d, yyyy"
        formatter.timeZone = .current
        return formatter
    }
    
    static func dateFrom(string: String) -> Date {
        return dateTimeFormatter.date(from: string) ?? Date()
    }
    
    static var dateTimeFormatter: DateFormatter {
        let formatter = dateFormatter
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = .current
        return formatter
    }
}
