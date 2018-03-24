//
//  MockData.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 17/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import Foundation

struct MockChallenge {
  var date: String
  var state: Bool
  var title: String
  var icon: String
  
  init(date: String, state: Bool, title: String, icon: String) {
    self.date = date
    self.state = state
    self.title = title
    self.icon = icon
  }
  
  static func getMockChallenges() -> [MockChallenge] {
    return [
      MockChallenge(date: "12:30", state: true, title: "Run 500 meters", icon: "hike"),
      MockChallenge(date: "13:30", state: false, title: "Take Subway", icon: "metro"),
      MockChallenge(date: "17:00", state: true, title: "Go party 1 hour", icon: "party")
    ]
  }
  
}
