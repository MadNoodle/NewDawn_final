///**
/**
NewDawn
Created by: Mathieu Janneau on 29/03/2018
Copyright (c) 2018 Mathieu Janneau
*/

import Foundation
import UIKit

/// Enumeration that stores all the possible mood icons to be
/// displayed on y axis of a chart
enum Icons: String {
  case superHappy = "happy-1"
  case happy = "happy"
  case neutral = "surprised"
  case sad = "sad-1"
  case dead = "dead"
}

/// Enumeration that stores the ratio to position icons
/// according to the rigth values of chart
enum Offset: CGFloat {
  case step1 = 1
  case step2 = 3.25
  case step3 = 5.5
  case step4 = 7.75
  case step5 = 10.0
}
