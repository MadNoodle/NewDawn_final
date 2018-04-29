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

struct TempUser {
  var username: String!
  var password: String!
  var lastName: String!
  var firstName: String!
  var key: String!
  var ref: DatabaseReference!
  
  init(username: String, password: String, lastName: String, firstName: String, key: String = "") {
    self.username = username
    self.password = password
    self.lastName = lastName
    self.firstName = firstName
    self.key = key
    self.ref = Database.database().reference()
  }
  
  init(snapshot: DataSnapshot) {
    guard let dict = snapshot.value as? [String: Any] else {return}
    self.username = dict["username"] as? String
    self.password = dict["password"] as? String
    self.lastName = dict["lastName"] as? String
    self.firstName = dict["firstName"] as? String
    self.ref = snapshot.ref
    self.key = snapshot.key
  }
  func toAnyObject() -> [String: Any] {
    return ["username": username, "password": password, "lastName": lastName, "firstName": firstName]
  }
}
