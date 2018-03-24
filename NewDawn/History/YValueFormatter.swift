///**
/**
NewDawn
Created by: Mathieu Janneau on 21/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Charts

class YValueFormatter: NSObject, IAxisValueFormatter {
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    
    var label = ""
    switch value {
    case 1:
      label = "e"
    case 2:
      label = "d"
    case 3:
      label = "c"
    case 4:
      label = "b"
    case 5:
      label = "a"
    default:
      break
    }
    return label
  }
  
  
}
