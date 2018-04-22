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
  var date: Date
  var state: Bool = false
  var title: String
  var icon: String
  var notificationIsActive: Bool = false
  var challengeLocation: String?
  var challengeLat: Double?
  var challengeLong: Double?
  var anxietyLevel: Int
  var benefitLevel: Int
  var category: ChallengeType
  var comment: String?
  var user: String?

  // image
  init(date: Double, state: Bool, title: String, category: ChallengeType, anxiety: Int, benefit: Int) {
    let currentDate = Date(timeIntervalSince1970: date)
    
    // Convert date to string and assign it to the date property
    self.date = currentDate
    self.state = state
    self.title = title
    self.category = category
    self.benefitLevel = benefit
    self.anxietyLevel = anxiety
    
    // assign icon according to category
    switch category {
    case .drive:
        self.icon = "drive"
    case .party:
        self.icon = "party"
    case .transport:
        self.icon = "metro"
    case .travel:
        self.icon = "travel"
    case .walk:
        self.icon = "hike"
    }
  }
  
  static func getMockChallenges() -> [MockChallenge] {
    return [
      MockChallenge(date: Date().timeIntervalSince1970 + 86400,
                    state: true, title: "Run 500 meters",
                    category: .walk,
                    anxiety: 5,
                    benefit: 5),
      MockChallenge(date: Date().timeIntervalSince1970 + 120000,
                    state: false,
                    title: "Take Subway",
                    category: .transport,
                    anxiety: 5,
                    benefit: 5),
      MockChallenge(date: Date().timeIntervalSince1970 + 46002,
                    state: true,
                    title: "Go party 1 hour",
                    category: .party,
                    anxiety: 5,
                    benefit: 5)
    ]
  }
  
}
