//
//  TimeInterval + extensions.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 20/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation

extension Int {

  func secondsToMinutesSeconds() -> String {
    return String(format: UIConfig.timerFormat , ((self % 3600) / 60), ((self % 3600) % 60))
  }
}
extension Date {
  
  func convertToString( format:DateFormat) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = .current
    formatter.dateFormat = format.rawValue
    return formatter.string(from: self)
  }
}
