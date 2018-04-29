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

struct TempMood {
  
  var user: String!
  var state: Int!
  var date: Double!
  var key: String!
  var ref: DatabaseReference!
  
  init(user: String, state: Int, date: Double, key: String = "") {
    self.user = user
    self.state = state
    self.date = date
    self.key = key
    self.ref = Database.database().reference()
  }
  
  init(snapshot: DataSnapshot) {
    guard let dict = snapshot.value as? [String: Any] else {return}
    self.user = dict["user"] as? String
    self.state = dict["state"] as? Int
    self.date = dict["date"] as? Double
    self.ref = snapshot.ref
    self.key = snapshot.key
  }
  func toAnyObject() -> [String: Any] {
    return ["user": user, "state": state, "date": date]
  }
}
