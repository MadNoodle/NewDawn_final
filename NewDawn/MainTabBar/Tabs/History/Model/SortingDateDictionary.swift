///**
/**
NewDawn
Created by: Mathieu Janneau on 21/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation

extension String {
  static let shortDate: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = .current
    formatter.dateStyle = .short
    return formatter
  }()
  
  var shortDate: Date? {
    return String.shortDate.date(from: self)
}
}
