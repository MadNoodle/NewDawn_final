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
    return String(format: "%02d:%02d", ((self % 3600) / 60), ((self % 3600) % 60))
  }
}
