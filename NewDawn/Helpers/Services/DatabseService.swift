///**
/**
NewDawn
Created by: Mathieu Janneau on 03/05/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import Firebase

class DatabaseService {
  
  // aplying Singleton pattern
  static let shared = DatabaseService()
  private init() {}
  let challengeUpdateRef = Database.database().reference().child("challenges")
  let challengeRef = Database.database().reference().child("challenges")
  
  let moodRef = Database.database().reference().child("moods")
  
  
  
  
}
