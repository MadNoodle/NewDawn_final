///**
/**
NewDawn
Created by: Mathieu Janneau on 30/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct FirebaseService {
  
  /// Firebase database reference
  var database: DatabaseReference = {
    return Database.database().reference()
  }()
  
  /// Firebase Storage reference
  var storage: StorageReference = {
    return Storage.storage().reference()
  }()
  
 
  func saveInfo(user: User!, username: String, password: String) {
    // create the user info dictionary
    
    let userInfo = ["email": user.email,"username": username, "password": password, "uid": user.uid]
    let userRef = database.ref.child("users").childByAutoId()
    userRef.setValue(userInfo)
  }
  
  func signIn(email: String, password: String, in controller: UIViewController) {
    
          Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
              print(error!.localizedDescription)
            } else {
              if let user = user {
                print("\(user.displayName) has succesfully signed in")
              }
  
    }
    }
  }
  

  

  
  func signUp(email: String, username: String, password: String, in controller: UIViewController) {
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
      if error != nil {
         UserAlert.show(title: "Sorry", message: error!.localizedDescription, controller: controller)
        print(error!.localizedDescription)
      } else {
        if let user = user {
        self.saveInfo(user: user, username: username, password: password)
        }
      }
    }
  }
  
  func loadChallenge(for user:String) -> [TempChallenge] {
   var newItems = [TempChallenge]()
  
        database.child("challenges").observe(.value, with: { (snapshot) in
          for item in snapshot.children {
            let newChallenge = TempChallenge(snapshot: item as! DataSnapshot)
            if newChallenge.user == user {
            newItems.insert(newChallenge, at: 0)
            }
          }
        }) { (error) in
          print(error.localizedDescription)
        }
    return newItems
  }

  func saveMood(for user: String, state: Int, date: Double) {
    let moodRef = database.child("moods").childByAutoId()
    let moodToStore = TempMood(user: user, state: state, date:date)
    moodRef.setValue(moodToStore.toAnyObject())
  }
}
