///**
/**
 NewDawn
 Created by: Mathieu Janneau on 03/05/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class DatabaseService {
  
  // aplying Singleton pattern
  static let shared = DatabaseService()
  private init() {}
  
  /// Firebase Reference to access challenges in database
  let challengeRef = Database.database().reference().child("challenges")
  /// Firebase Reference to access mood in database
  let moodRef = Database.database().reference().child("moods")
  /// Firebase Reference to access Storage for images
  let storageRef = Storage.storage().reference()
  
  
  
  /// This methods creates a Challenge entry in the firebase database
  func createChallenge(dueDate: TimeInterval, user: String, name: String, objective: String, anxietyLevel: Int, benefitLevel: Int, isDone: Int, isNotified: Int, isSuccess: Int, destination: String, destinationLat: Double, destinationLong: Double, completionHandler: @escaping(_ error: Error?) -> Void) {
    // Set new parameters
    let challengeToStore = ["user": user, "name": name, "objective": objective, "dueDate": dueDate, "anxietyLevel": anxietyLevel, "benefitLevel": benefitLevel, "isNotified": isNotified, "isDone": isDone, "isSuccess": isSuccess, "destination": destination, "destinationLat": destinationLat, "destinationLong": destinationLong, "comment": ""] as [String: Any]
    // update DB
    
    challengeRef.childByAutoId().setValue(challengeToStore) { (error, _) in
      // send back error if there is
      if error != nil {
        completionHandler(error)
      }
      completionHandler(nil)
      
    }
  }
  
  /// This methods update an existing Challenge entry in the firebase database
  func updateChallenge(dueDate: TimeInterval, key: String?, user: String, name: String, objective: String, anxietyLevel: Int, benefitLevel: Int, isDone: Int, isNotified: Int, isSuccess: Int, destination: String, destinationLat: Double, destinationLong: Double, completionHandler: @escaping(_ error: Error?) -> Void) {
    // Set new parameters
    let parameters = ["user": user, "name": name, "objective": objective, "dueDate": dueDate, "anxietyLevel": anxietyLevel, "benefitLevel": benefitLevel, "isNotified": isNotified, "isDone": isDone, "isSuccess": isSuccess, "destination": destination, "destinationLat": destinationLat, "destinationLong": destinationLong, "comment": ""] as [String: Any]
    
    // update DB
    challengeRef.child(key!).updateChildValues(parameters) { (error, _) in
      if error != nil {
        completionHandler(error)
      }
      completionHandler(nil)
    }
  }
  
  /// This methods fetch all challenges for a given user
  func loadChallenges(for currentUser: String, completionHandler: @escaping (_ challengeArray: [Challenge]?)->()) {
    // fetch data from firebase
    challengeRef.observe(.value, with: { (snapshot) in
  
        // array to store results
        var challengeArray: [Challenge] = []
        var newItems = [Challenge]()
        // Convert results in challenges objects
        for item in snapshot.children {
          let newChallenge = Challenge(snapshot: (item as? DataSnapshot)!)
          newItems.insert(newChallenge, at: 0)
        }
        // filter to retrieve only logged user's challenge
        for item in newItems where item.user == currentUser {
          challengeArray.insert(item, at: 0)
        }
        // sort challenges by ascending dates
        challengeArray.sort(by: {$0.dueDate < $1.dueDate})
        
        // returns Value
        if challengeArray.isEmpty {
          completionHandler(nil)
        }else {
          completionHandler(challengeArray)
        }
      
    })
  }
  
  
  
  
  /// Convert and Upload image on Firebase Storage
  ///
  func uploadImagePic(data: Data, for key: String, isDone: Int, isSuccess: Int, comment: String, completionHandler: @escaping(_ status: String, _ error: Error?) -> Void) {
    // Create the file metadata
    let metadata = StorageMetadata()
    metadata.contentType = "image/png"
    
    let uuid = UUID().uuidString
    // Upload file and metadata to the object 'images/mountains.jpg'
    let uploadTask = storageRef.child(uuid).putData(data, metadata: metadata) {(_, error) in
      if error != nil {
        completionHandler("failure",error)
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
            completionHandler("success",nil)
          }
        } else {
         completionHandler("failure",error)
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
  
  /// Delete all challenges for a user
  ///
  /// - Parameter user: String username
  func purgeChallenges(for user: String) {
    // Laod all challenge
    challengeRef.observe(.value) { (snapshot) in
      for item in snapshot.children {
        
        let newChallenge = Challenge(snapshot: (item as? DataSnapshot)!)
        // filter for the choosen user
        if newChallenge.user == user {
         // delete
          self.challengeRef.child(newChallenge.key).removeValue()
        }
      }
    }
  }
  
  
  /// Create a Mood entry in Firebase database
  ///
  /// - Parameters:
  ///   - user: String owner of the mood
  ///   - state: Int from 0 to 4, each value is equivalent to a mood
  ///   - date: Double saving time
  func saveMood(user: String, state: Int, date: Double, onCompleted: @escaping( _ status: String) -> Void) {
    let newMood = ["user": user,
                   "state": state,
                   "date": date] as [String: Any]
    moodRef.childByAutoId().setValue(newMood)
    onCompleted("completed")
  }
  
 
  
  /// Load moods stored in Firebase Database
  ///
  /// - Parameters:
  ///   - user: String Username
  ///   - completionHandler: ([Mood], Error?) -> Void
  func loadMoods(for user: String,completionHandler:@escaping (_ moodArray: [Mood], _ error: Error?)->()) {
    
    moodRef.observe(.value, with: {(snapshot) in
      var moodArray = [Mood]()
      var newItems = [Mood]()
      for item in snapshot.children {
        let newMood = Mood(snapshot: item as! DataSnapshot)
        newItems.insert(newMood, at: 0)
      }
      for item in newItems where item.user == user {
        moodArray.insert(item, at: 0)
      }
      
      
      moodArray.sort(by: {$0.date < $1.date})
      if moodArray.isEmpty {
        completionHandler([], nil)
      }else {
        completionHandler(moodArray, nil)
      }}) { (error) in
        completionHandler([], error)
    }
  }
  
  /// Delete all modds for a particular user
  ///
  /// - Parameter user: String username
  func purgeMoods(for user: String, completionHandler : @escaping( _ status: String) -> Void) {
    moodRef.observe(.value) { (snapshot) in
      for item in snapshot.children {
        guard let mood = item as? DataSnapshot else { return}
        let newMood = Mood(snapshot: mood)
        if newMood.user == user {
          self.moodRef.child(newMood.key).removeValue()
        }
        completionHandler("purged")
      }
    }
  }
  
  /// Fetch dates for challenges
  ///
  /// - Parameters:
  ///   - currentUser: String username
  ///   - completionHandler: [String] array of formated date for each stored challenges
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
  
  func loadSuccessChallengesCount(for user: String, completion: @escaping (_ result: Int,_ error :Error?) -> Void)  {
    
    var doneChallenges = [Challenge]()
    
    challengeRef.observe(.value, with: { (snapshot) in
      var newItems = [Challenge]()
      for item in snapshot.children {
        let newChallenge = Challenge(snapshot: (item as? DataSnapshot)!)
        newItems.insert(newChallenge, at: 0)
      }
      
      for item in newItems where item.isDone == 1 {
        doneChallenges.append(item)
        completion(doneChallenges.count, nil)
      }
      
    }, withCancel: { (error) in
      completion(0, error)
    })
    
  }
}
