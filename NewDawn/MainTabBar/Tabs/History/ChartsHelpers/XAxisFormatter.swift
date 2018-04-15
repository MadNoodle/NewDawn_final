///**
/**
NewDawn
Created by: Mathieu Janneau on 22/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import Charts

class XAxisFormatter: NSObject, IAxisValueFormatter {
  
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    // convert Double in Date
    let date = Date(timeIntervalSince1970: TimeInterval(value))
    // Format date string
    let dayTimePeriodFormatter = DateFormatter()
    
    dayTimePeriodFormatter.dateFormat = UIConfig.chartDateFormat.rawValue
    return dayTimePeriodFormatter.string(from: date)
  }
  
}
