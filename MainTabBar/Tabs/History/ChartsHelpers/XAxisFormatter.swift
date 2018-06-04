///**
/**
NewDawn
Created by: Mathieu Janneau on 22/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import Charts

/// Handles the display of date formatted X axis on a chart
class XAxisFormatter: NSObject, IAxisValueFormatter {
  
  /// defines x axis custom values to display dates
  ///
  /// - Parameters:
  ///   - value: Double Time Interval since 1970
  ///   - axis: X Axis
  /// - Returns: String formatted date
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    // convert Double in Date
    let date = Date(timeIntervalSince1970: TimeInterval(value))
    // Format date string
    let dayTimePeriodFormatter = DateFormatter()
    
    dayTimePeriodFormatter.dateFormat = UIConfig.chartDateFormat.rawValue
    return dayTimePeriodFormatter.string(from: date)
  }
  
}
