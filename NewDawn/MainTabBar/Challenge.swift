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

struct Challenge {
  
  var ref: DatabaseReference!
  var key: String!
  var user: String!
  var name: String!
  var objective: String!
  var dueDate: Double!
  var isDone: Int!
  var isNotified: Int!
  var isSuccess: Int!
  var anxietyLevel: Int!
  var benefitLevel: Int!
  var comment: String?
  var destination: String?
  var destinationLat: Double?
  var destinationLong: Double?
  var felt: Int?
  var map: Data?
  
  
  init(user: String, name: String, objective: String, dueDate: Double, anxietyLevel: Int, benefitLevel: Int, isNotified: Bool,isDone: Bool,isSuccess:Bool, destination: String?, destinationLat: Double?, destinationLong: Double?, key: String = "") {
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
  
  init(snapshot: DataSnapshot) {
    guard let dict = snapshot.value as? [String:Any] else { return}
    self.user = dict["user"] as! String
    self.name = dict["name"] as! String
    self.objective = dict["objective"] as! String
    self.dueDate = dict["dueDate"] as! Double
    self.anxietyLevel = dict["anxietyLevel"] as! Int
    self.benefitLevel = dict["benefitLevel"] as! Int
    self.isNotified = dict["isNotified"] as! Int
    self.isDone = dict["isdone"] as? Int
    self.isSuccess = dict["isSuccess"] as? Int
    self.comment = dict["comment"] as? String
    self.destinationLat = dict["latitude"] as? Double
    self.destinationLong = dict["longitude"] as? Double
    self.key = snapshot.key
    self.ref = snapshot.ref
  }
  
  func toAnyObject() -> [String:Any] {
    return ["user": user, "name": name, "objective": objective, "dueDate": dueDate, "anxietyLevel": anxietyLevel, "benefitLevel": benefitLevel, "felt": felt as Any, "isNotified": isNotified, "isDone": isDone, "isSuccess": isSuccess, "comment": comment as Any, "destination": destination as Any, "destinationLat": destinationLat as Any, "destinationLong": destinationLong as Any]
  }
}
