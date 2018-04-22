///**
/**
NewDawn
Created by: Mathieu Janneau on 20/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation

struct FormattedChallenge {
   var anxietyLevel: Int32
   var benefitLevel: Int32
   var comment: String?
   var destination: String?
   var destinationLat: Double
   var destinationLong: Double
   var dueDate: Double
   var felt: Int32
   var isDone: Bool
   var isNotified: Bool
   var isSuccess: Bool
   var map: NSData?
   var name: String?
   var objective: String?
  var user: String?
   var formattedDate: String
  
  init (challenge: Challenge) {
    self.anxietyLevel = challenge.anxietyLevel
    self.benefitLevel = challenge.benefitLevel
    self.comment = challenge.comment
    self.destination = challenge.destination
    self.destinationLat = challenge.destinationLat
    self.destinationLong = challenge.destinationLong
    self.dueDate = challenge.dueDate
    self.felt = challenge.felt
    self.isDone = challenge.isDone
    self.isNotified = challenge.isNotified
    self.isSuccess = challenge.isSuccess
    self.map = challenge.map
    self.name = challenge.name
    self.objective = challenge.objective
    self.user = challenge.user
    let dateFormatted = Date(timeIntervalSince1970: challenge.dueDate)
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormat.sortingFormat.rawValue
    self.formattedDate = formatter.string(from: dateFormatted)
    print(self.formattedDate)
  }
}
