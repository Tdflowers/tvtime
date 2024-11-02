//
//  DateFormatter+.swift
//  BingeTime
//
//  Created by Tyler Flowers on 7/7/24.
//

import Foundation

extension DateFormatter {
  static let yyyyMMdd: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
