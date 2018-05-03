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

  let challengeRef = Database.database().reference().child("challenges")
  
  let moodRef = Database.database().reference().child("moods")
  let storageRef = Storage.storage().reference()
  
  func updateChallenge(dueDate: TimeInterval,key: String?, user: String, name: String, objective: String, anxietyLevel: Int, benefitLevel: Int, isDone: Bool,isNotified: Bool, isSuccess: Bool,destination: String,destinationLat: Double, destinationLong: Double) {
    // Set new parameters
    let parameters = ["user":user,"name": name, "objective": objective, "dueDate": dueDate, "anxietyLevel": anxietyLevel, "benefitLevel": benefitLevel, "isNotified": isNotified, "isDone": isDone, "isSuccess": isSuccess, "destination": destination, "destinationLat": destinationLat, "destinationLong": destinationLong, "comment": ""] as [String : Any]
    
    // update DB
    challengeRef.child(key!).updateChildValues(parameters)
  }
  
  func createChallenge(dueDate: TimeInterval, user: String, name: String, objective: String, anxietyLevel: Int, benefitLevel: Int, isDone: Bool,isNotified: Bool, isSuccess: Bool,destination: String,destinationLat: Double, destinationLong: Double) {
     // Set new parameters
    let challengeToStore = ["user":user,"name": name, "objective": objective, "dueDate": dueDate, "anxietyLevel": anxietyLevel, "benefitLevel": benefitLevel, "isNotified": isNotified, "isDone": isDone, "isSuccess": isSuccess, "destination": destination, "destinationLat": destinationLat, "destinationLong": destinationLong, "comment": ""] as [String : Any]
    // update DB
    challengeRef.childByAutoId().setValue(challengeToStore)
  }
  
  func saveMood(user: String, state: Int, date: Double) {
    let newMood = ["user": user,
                   "state": state,
                   "date": date] as [String : Any]
    moodRef.childByAutoId().setValue(newMood)
  }
  
  
  func loadChallenges(for user: String) -> [Challenge] {
    var data = [Challenge]()
    challengeRef.observe(.value) { (snapshot) in
      
      var newItems = [Challenge]()
      for item in snapshot.children {
        
        let newChallenge = Challenge(snapshot: item as! DataSnapshot)
        newItems.insert(newChallenge, at: 0)
      }
      for item in newItems where item.user == user {
        data.insert(item, at: 0)
      }
      
    }
    return data
  }
  
  func loadEventsDatabase(for user: String) -> [String] {
    var dates = [String]()
    let dateFormatter = DateFormatter()
    challengeRef.observe(.value, with: { (snapshot) in
      var newItems = [Challenge]()
      for item in snapshot.children {
        let newChallenge = Challenge(snapshot: item as! DataSnapshot)
        newItems.insert(newChallenge, at: 0)
      }
      for item in newItems where item.user == user{
        dateFormatter.dateFormat = DateFormat.annual.rawValue
        let eventDate = dateFormatter.string(from: Date(timeIntervalSince1970: item.dueDate))
        dates.append(eventDate)
      }
    })
    return dates
  }
  
  func uploadImagePic(data: Data,for key: String, isDone: Int, isSuccess: Int, comment: String){
    // Local file you want to upload
    //let localFile = URL(string: "path/to/image")!
    
    // Create the file metadata
    let metadata = StorageMetadata()
    metadata.contentType = "image/png"
    
    let uuid = UUID().uuidString
    // Upload file and metadata to the object 'images/mountains.jpg'
    let uploadTask = storageRef.child(uuid).putData(data, metadata: metadata) {(metadata, error) in
      if error != nil {
        print(error!.localizedDescription)
      }
      self.storageRef.child(uuid).downloadURL(completion: { (url, error) in
        if (error == nil) {
          if let downloadUrl = url {
            // Make you download string
            let downloadString = downloadUrl.absoluteString
            let parameters: [String: Any] = ["isDone": isDone, "comment": comment, "isSuccess": isSuccess, "map": downloadString]
            DatabaseService.shared.challengeRef.child(key).updateChildValues(parameters)
          }
        } else {
          // Do something if error
        }
      })
    }
   
    
    // Listen for state changes, errors, and completion of the upload.
    uploadTask.observe(.resume) { snapshot in
      // Upload resumed, also fires when the upload starts
    }
    
    uploadTask.observe(.pause) { snapshot in
      // Upload paused
    }
    
    uploadTask.observe(.progress) { snapshot in
      // Upload reported progress
      let percentComplete = 1000.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
      print(percentComplete)
    }
    
    uploadTask.observe(.success) { snapshot in
      // Upload completed successfully
    }
    
    uploadTask.observe(.failure) { snapshot in
      if let error = snapshot.error as NSError? {
        switch (StorageErrorCode(rawValue: error.code)!) {
        case .objectNotFound:
          
          print("File doesn't exist")
          break
        case .unauthorized:
          print("User doesn't have permission to access file")
          break
        case .cancelled:
          print("User canceled the upload")
          break
          
          /* ... */
          
        case .unknown:
          // Unknown error occurred, inspect the server response
          break
        default:
          // A separate error occurred. This is a good place to retry the upload.
          break
        }
      }
    }
  }
    
    
  
}
