//
//  TImerClock.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 21/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import Foundation
import UIKit

class TimerClock {
  var timer = Timer()
  

  
  func stopTimer(){
    timer.invalidate()
  }
}
