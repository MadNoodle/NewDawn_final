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

/// This data model refers to a Mood that user can store and retrieve in history tab
struct Mood {
  /// user that owns the mood
  var user: String!
  /// value of the mood
  var state: Int!
  /// property that stores the recording date of the mood
  var date: Double!
  /// Firebase database key
  var key: String!
  /// Firebase database reference
  var ref: DatabaseReference!
  
  init(user: String, state: Int, date: Double, key: String = "") {
    self.user = user
    self.state = state
    self.date = date
    self.key = key
    self.ref = Database.database().reference()
  }
  
  /// Custom init to retrieve a mood from the JSON result from firebase database
  ///
  /// - Parameter snapshot: DataSnapshot response from firebase
  init(snapshot: DataSnapshot) {
    // Convert json to dictionary
    guard let dict = snapshot.value as? [String: Any] else {return}
    self.user = dict["user"] as? String
    self.state = dict["state"] as? Int
    self.date = dict["date"] as? Double
    self.ref = snapshot.ref
    self.key = snapshot.key
  }
  
  
  /// Convert data to firebase friendly format for saving
  ///
  /// - Returns: [String: Any]
  func toAnyObject() -> [String: Any] {
    return ["user": user, "state": state, "date": date]
  }
}
