///**
/**
 NewDawn
 Created by: Mathieu Janneau on 29/04/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import Foundation
import Firebase
import FirebaseDatabase

/// This data model refers to a Challenge object that user can store
struct Challenge {
  /// Firebase database reference
  var ref: DatabaseReference!
  /// Firebase database key
  var key: String!
  /// user that owns the mood
  var user: String!
  /// Chalenge title
  var name: String!
  /// Category in which cchallenge appears
  var objective: String!
  /// Date chosen by users to process the challenge
  var dueDate: Double!
  /// This property stores the achievement or not of the task
  var isDone: Int!
  /// This property stores whether the user wants to be notified or not 10 minutes before due date
  var isNotified: Int!
  /// This property stores the final state success or failure
  var isSuccess: Int!
  /// Anticipated anxiety level
  var anxietyLevel: Int!
  /// Anticipated Benefit level that user is waiting for when achieving task
  var benefitLevel: Int!
  /// Post task felt anxiety
  var felt: Int?
  /// Property that stores a potential comment
  var comment: String?
  /// Location name associated with the task
  var destination: String?
  /// Location latitude
  var destinationLat: Double?
  /// Location longitude
  var destinationLong: Double?
  /// Map image of task
  var map: Data?
  
  init(user: String, name: String, objective: String, dueDate: Double, anxietyLevel: Int, benefitLevel: Int, isNotified: Bool, isDone: Bool, isSuccess: Bool, destination: String?, destinationLat: Double?, destinationLong: Double?, key: String = "") {
    self.ref =  Database.database().reference()
    self.key = key
    self.user = user
    self.name = name
    self.objective = objective
    self.dueDate = dueDate
    self.anxietyLevel = anxietyLevel
    self.benefitLevel = benefitLevel
    if isNotified {self.isNotified = 1} else {self.isNotified = 0}
    if isDone {self.isDone = 1} else {self.isDone = 0}
    if isSuccess {self.isSuccess = 1} else {self.isSuccess = 0}
    self.comment = "No comment"
    if let location = destination {
      self.destination = location
      
    }
    if let latitude = destinationLat {
      self.destinationLat = latitude
    }
    if let longitude = destinationLong {
      self.destinationLong = longitude
    }
  }
 
  /// Custom init to retrieve a mood from the JSON result from firebase database
  ///
  /// - Parameter snapshot: DataSnapshot response from firebase
  init(snapshot: DataSnapshot) {
    guard let dict = snapshot.value as? [String: Any] else { return}
    self.user = dict["user"] as? String
    self.name = dict["name"] as? String
    self.objective = dict["objective"] as? String
    self.dueDate = dict["dueDate"] as? Double
    self.anxietyLevel = dict["anxietyLevel"] as? Int
    self.benefitLevel = dict["benefitLevel"] as? Int
    self.isNotified = dict["isNotified"] as? Int
    self.isDone = dict["isdone"] as? Int
    self.isSuccess = dict["isSuccess"] as? Int
    self.comment = dict["comment"] as? String
    self.destinationLat = dict["latitude"] as? Double
    self.destinationLong = dict["longitude"] as? Double
    self.key = snapshot.key
    self.ref = snapshot.ref
  }
  
  /// Convert data to firebase friendly format for saving
  ///
  /// - Returns: [String: Any]
  func toAnyObject() -> [String: Any] {
    return ["user": user, "name": name, "objective": objective, "dueDate": dueDate, "anxietyLevel": anxietyLevel, "benefitLevel": benefitLevel, "felt": felt as Any, "isNotified": isNotified, "isDone": isDone, "isSuccess": isSuccess, "comment": comment as Any, "destination": destination as Any, "destinationLat": destinationLat as Any, "destinationLong": destinationLong as Any]
  }
}
