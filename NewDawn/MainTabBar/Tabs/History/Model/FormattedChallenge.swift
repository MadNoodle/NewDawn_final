///**
/**
NewDawn
Created by: Mathieu Janneau on 20/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation

struct FormattedChallenge {
   var anxietyLevel: Int?
   var benefitLevel: Int?
   var comment: String?
   var destination: String?
   var destinationLat: Double?
   var destinationLong: Double?
   var dueDate: Double?
   var felt: Int?
   var isDone: Bool?
   var isNotified: Bool?
   var isSuccess: Bool?
   var map: Data?
   var name: String?
   var objective: String?
  var user: String?
   var formattedDate: String?
  
  init (challenge: Challenge) {
    self.anxietyLevel = challenge.anxietyLevel
    self.benefitLevel = challenge.benefitLevel
    self.comment = challenge.comment
    self.destination = challenge.destination
    if let latitude = challenge.destinationLat {
      self.destinationLat = latitude
    }
    if let longitude = challenge.destinationLong {
    self.destinationLong = longitude
    }
    self.dueDate = challenge.dueDate
    if let feltAnxiety = challenge.felt {
    self.felt = feltAnxiety
    }
    if challenge.isDone == 1 {self.isDone = true} else {self.isDone = false}
     if challenge.isNotified == 1 {self.isNotified = true} else {self.isNotified = false}
     if challenge.isSuccess == 1 {self.isSuccess = true} else {self.isSuccess = false}
    
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
