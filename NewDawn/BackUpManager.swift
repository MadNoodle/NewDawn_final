///**
/**
NewDawn
Created by: Mathieu Janneau on 28/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import Firebase
import FirebaseDatabase
import CoreData

// 2 types of connexions


class FirebaseManager {
  
  static var ref: DatabaseReference = Database.database().reference()
 
  // ////////////////////// //
  // MARK: - CREATE METHODS //
  // ////////////////////// //
  
  static func createUser(_ user: String,with password: String) {
    
    DispatchQueue.main.async {
      let userInfo = ["username": user,
                      "password": password ]
      ref.child("users").childByAutoId().setValue(userInfo)
    }
  }
  
  static func createChallenge(for user: String) {
    
    DispatchQueue.main.async {
      let challenges: [Challenge] = CoreDataService.loadData(for: user)
      let JSONChallenges = JSONify(challenges)
      for item in JSONChallenges
      {
        let userInfo = ["challenge": item]
      ref.child("challenges").childByAutoId().setValue(userInfo)}
    }
  }
  
  static func createMood(for user: String) {
    
    DispatchQueue.main.async {
      let moods: [Mood] = CoreDataService.loadData(for: user)
      let JSONMoods = JSONify(moods)
      for item in JSONMoods
      {
        let userInfo = ["moods": item]
        ref.child("moods").childByAutoId().setValue(userInfo)}
    }
  }
  
  // //////////////////// //
  // MARK: - READ METHODS //
  // //////////////////// //
  
  
  static func loadChallenges(for user: String) {
   
  }
  static func JSONify(_ data: [NSManagedObject]) -> [String] {
    var storedObject = [String]()
    for item in data {
      // convert ManagedObject to Dictionary
      let keys = Array(item.entity.attributesByName.keys)
      let dict = item.dictionaryWithValues(forKeys: keys)
      
      // Serialize to JSON
      do{
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        let reqJSONStr = String(data: jsonData, encoding: .utf8)
        
        storedObject.append(reqJSONStr!)
      }catch let error {
        print(error.localizedDescription)
      }
      
    }
   
    return storedObject
  }
}
// check connexion available


// SYNC

// Compare last update date != firebase ->

  // if date in Core data > firebase -> Save Core Data to Firebase

  // else fetch FireBase -> Core Data



// SAVE

  // if web available CoreData -> fireBase

    // save in core Data for user

    // convert to Json

    // Send to firebase
        // send last update time

  // if web not available CoreData

  // when apps opens check last update date if last update date != firebase -> Save Core Data to Firebase

// FETCH

  // if web available fetch for user

    // parse JSON

    // Inject in core data

    // load core data in UI

  // if web not available

    // load core data

