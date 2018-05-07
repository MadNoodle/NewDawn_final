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
  
  func updateChallenge(dueDate: TimeInterval, key: String?, user: String, name: String, objective: String, anxietyLevel: Int, benefitLevel: Int, isDone: Bool, isNotified: Bool, isSuccess: Bool, destination: String, destinationLat: Double, destinationLong: Double) {
    // Set new parameters
    let parameters = ["user": user, "name": name, "objective": objective, "dueDate": dueDate, "anxietyLevel": anxietyLevel, "benefitLevel": benefitLevel, "isNotified": isNotified, "isDone": isDone, "isSuccess": isSuccess, "destination": destination, "destinationLat": destinationLat, "destinationLong": destinationLong, "comment": ""] as [String: Any]
    
    // update DB
    challengeRef.child(key!).updateChildValues(parameters)
  }
  
  func createChallenge(dueDate: TimeInterval, user: String, name: String, objective: String, anxietyLevel: Int, benefitLevel: Int, isDone: Bool, isNotified: Bool, isSuccess: Bool, destination: String, destinationLat: Double, destinationLong: Double) {
     // Set new parameters
    let challengeToStore = ["user": user, "name": name, "objective": objective, "dueDate": dueDate, "anxietyLevel": anxietyLevel, "benefitLevel": benefitLevel, "isNotified": isNotified, "isDone": isDone, "isSuccess": isSuccess, "destination": destination, "destinationLat": destinationLat, "destinationLong": destinationLong, "comment": ""] as [String: Any]
    // update DB
    challengeRef.childByAutoId().setValue(challengeToStore)
  }
  
  func saveMood(user: String, state: Int, date: Double) {
    let newMood = ["user": user,
                   "state": state,
                   "date": date] as [String: Any]
    moodRef.childByAutoId().setValue(newMood)
  }
  


  
  func uploadImagePic(data: Data, for key: String, isDone: Int, isSuccess: Int, comment: String) {
    // Create the file metadata
    let metadata = StorageMetadata()
    metadata.contentType = "image/png"
    
    let uuid = UUID().uuidString
    // Upload file and metadata to the object 'images/mountains.jpg'
    let uploadTask = storageRef.child(uuid).putData(data, metadata: metadata) {(_, error) in
      if error != nil {
        print(error!.localizedDescription)
      }
      self.storageRef.child(uuid).downloadURL(completion: { (url, error) in
        if error == nil {
          if let downloadUrl = url {
            // Make you download string
            let downloadString = downloadUrl.absoluteString
            let parameters: [String: Any] = ["isDone": isDone,
                                             "comment": comment,
                                             "isSuccess": isSuccess,
                                             "map": downloadString]
            DatabaseService.shared.challengeRef.child(key).updateChildValues(parameters)
          }
        } else {
          // Do something if error
        }
      })
    }

    uploadTask.observe(.progress) { snapshot in
      // Upload reported progress
      let percentComplete = 1000.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
      print(percentComplete)
    }

    uploadTask.observe(.failure) { snapshot in
      if let error = snapshot.error as NSError? {
        switch StorageErrorCode(rawValue: error.code)! {
        case .objectNotFound:
          
          print("File doesn't exist")
          
        case .unauthorized:
          print("User doesn't have permission to access file")
          
        case .cancelled:
          print("User canceled the upload")

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
    
  func purgeChallenges(for user: String) {
    challengeRef.observe(.value) { (snapshot) in
      for item in snapshot.children {
        
        let newChallenge = Challenge(snapshot: (item as? DataSnapshot)!)
        if newChallenge.user == user {
          self.challengeRef.child(newChallenge.key).removeValue()
        }
      }
    }
  }

  func purgeMoods(for user: String) {
    moodRef.observe(.value) { (snapshot) in
      for item in snapshot.children {
        let newMood = TempMood(snapshot: (item as? DataSnapshot)!)
        if newMood.user == user {
          self.moodRef.child(newMood.key).removeValue()
        }
      }
    }
  }
  
  func loadMoods(for user: String,completionHandler:@escaping (_ moodArray: [TempMood]?)->()) {
    
    moodRef.observe(.value){ (snapshot) in
      var moodArray = [TempMood]()
      var newItems = [TempMood]()
      for item in snapshot.children {
        let newMood = TempMood(snapshot: item as! DataSnapshot)
        newItems.insert(newMood, at: 0)
      }
      for item in newItems where item.user == user {
        moodArray.insert(item, at: 0)
      }
      
    
    moodArray.sort(by: {$0.date < $1.date})
    if moodArray.isEmpty {
      completionHandler(nil)
    }else {
      completionHandler(moodArray)
    }
  }
  }

  func loadChallenges(for currentUser: String, completionHandler:@escaping (_ challengeArray: [Challenge]?)->()) {
    challengeRef.observe(.value) { snapshot in
      var challengeArray: [Challenge] = []
      var newItems = [Challenge]()
      for item in snapshot.children {
        let newChallenge = Challenge(snapshot: (item as? DataSnapshot)!)
        newItems.insert(newChallenge, at: 0)
      }
      for item in newItems where item.user == currentUser {
        challengeArray.insert(item, at: 0)
      }
      challengeArray.sort(by: {$0.dueDate < $1.dueDate})
      
      if challengeArray.isEmpty {
        completionHandler(nil)
      }else {
        completionHandler(challengeArray)
      }
    }
  }
  
  func loadEventsDatabase(for currentUser: String, completionHandler:@escaping (_ eventArray: [String]?)->()) {
    DatabaseService.shared.challengeRef.observe(.value, with: { (snapshot) in
      var eventArray = [String]()
      var newItems = [Challenge]()
      for item in snapshot.children {
        guard let challenge = item as? DataSnapshot else { return}
        let newChallenge = Challenge(snapshot: challenge)
        newItems.insert(newChallenge, at: 0)
      }
      for item in newItems where item.user == currentUser {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.annual.rawValue
        let eventDate = dateFormatter.string(from: Date(timeIntervalSince1970: item.dueDate))
        eventArray.append(eventDate)
      }
      
      if eventArray.isEmpty {
        completionHandler(nil)
      }else {
        completionHandler(eventArray)
      }
    })
  }
  
  func getSucceededChallengeByDate(data: [Challenge]) -> [(Double, Double)] {
    
    var formattedChallenges = [FormattedChallenge]()
    
    // convert
    for point in data {
      let newFormatChallenge = FormattedChallenge(challenge: point)
      formattedChallenges.append(newFormatChallenge)
    }
    
    // sort
    formattedChallenges.sort(by: { $0.formattedDate?.compare($1.formattedDate!) == .orderedAscending})
    
    // sort them by date
    var succeededChallengeDictionary = [String: Int]()
    for challenge in formattedChallenges {
      
      if let count = succeededChallengeDictionary[challenge.formattedDate!] {
        succeededChallengeDictionary[challenge.formattedDate!] = count + 1
      } else {
        succeededChallengeDictionary[challenge.formattedDate!] = 1
      }
    }
    
    let tuples = succeededChallengeDictionary.sorted {
      return $0.key < $1.key
    }
    
    var myArrayOfTuples = [(Double, Double)]()
    
    let dateTimeFormatter = DateFormatter()
    dateTimeFormatter.timeZone = .current
    dateTimeFormatter.dateFormat = DateFormat.sortingFormat.rawValue
    
    for tuple in tuples {
      if let dateConverted = dateTimeFormatter.date(from: tuple.0) {
        let newDate = dateConverted.timeIntervalSince1970
        let newtuple = (newDate, Double(tuple.1))
        myArrayOfTuples.append(newtuple)
      }
      
    }
    return myArrayOfTuples
  }
  
  func loadSuccessChallengesCount(for user: String) -> Int {
    var result = 0
    var doneChallenges = [Challenge]()
   challengeRef.observe(.value, with: { (snapshot) in
      var newItems = [Challenge]()
      for item in snapshot.children {
        let newChallenge = Challenge(snapshot: (item as? DataSnapshot)!)
        newItems.insert(newChallenge, at: 0)
      }
      for item in newItems where item.user == user && item.isDone == 1 {
        doneChallenges.append(item)
        result = doneChallenges.count
      }
    })
    return result
  }
}
