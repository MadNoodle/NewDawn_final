/////**
///**
// NewDawn
// Created by: Mathieu Janneau on 16/04/2018
// Copyright (c) 2018 Mathieu Janneau
// */
//// swiftlint:disable trailing_whitespace
//
//import Foundation
//import UIKit
//import CoreData
//
//class CoreDataService {
//  
//  // iniatlize app delegate
//  static let appDelegate = UIApplication.shared.delegate as? AppDelegate
//  static let managedContext = appDelegate?.persistentContainer.viewContext
//  
//  static func saveUser(lastName: String, firstName: String, email: String, password: String) {
//    
//    // Create entity
//    let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext!)
//    let user = NSManagedObject(entity: entity!,
//                               insertInto: managedContext)
//    user.setValue(lastName, forKey: "lastName")
//    user.setValue(firstName, forKey: "firstName")
//    user.setValue(email, forKey: "email")
//    user.setValue(password, forKey: "password")
//    
//    save()
//    print(user)
//  }
//  
//  static func saveChallenge(user:String, name: String, dueDate: Double, isNotified: Bool, anxietyLevel: Int, benefitLevel: Int, objective: String, location: ChallengeDestination?) {
//    
//    let data: [Challenge] = loadData(for: user)
//    print(data)
//    for chall in data where name == chall.name && dueDate == dueDate {
//      delete(chall)
//      print("duplicate deleted")
//      
//    }
//    print(data)
//    // Create entity
//    
//    let challenge = NSEntityDescription.insertNewObject(forEntityName: "Challenge", into: managedContext!) as! Challenge
//    challenge.user = user
//    challenge.objective = objective
//    challenge.name = name
//    challenge.dueDate = dueDate
//    challenge.isNotified = isNotified
//    challenge.anxietyLevel = Int32(anxietyLevel)
//    challenge.benefitLevel = Int32(benefitLevel)
//    challenge.isDone = false
//    if let targetLocation = location {
//     
//      challenge.destination = targetLocation.locationName
//      challenge.destinationLat = targetLocation.lat
//      challenge.destinationLong = targetLocation.long
//    }
//    
//    save()
//     let data2: [Challenge] = loadData(for: user)
//    print(data2)
//  }
//  
//  static func saveMood(user:String,date: Date, value: Int) {
//    let data: [Mood] = loadData(for: user)
//    let formerMood = data.last
//    let saveDate = date.timeIntervalSince1970
//    // Replace former Mood if under 5 hour
//    // optionnel déballage former mood
//    if let previousMood = formerMood{
//    if ( previousMood.date - saveDate) <= 19200 {
//      deleteMood(formerMood!)
//      }
//    }
//    // Create entity
//    
//    let mood = NSEntityDescription.insertNewObject(forEntityName: "Mood", into: managedContext!) as! Mood
//    mood.user = user
//    
//    mood.date = saveDate
//    mood.state = Int32(value)
//    save()
//    print(mood)
//  }
//  
//
//  static func saveImage(_ map: UIView) {    
//    // Define entity
//    let challenge = NSEntityDescription.insertNewObject(forEntityName: "Challenge", into: managedContext!) as! Challenge
//    // convert mapView to image
//    let screenshot = UIImage(view:map)
//    // convert image to data
//    let mapImage = UIImagePNGRepresentation(screenshot) as NSData?
//    // store in core data
//    
//      challenge.map = mapImage
//      save()
//  }
//  
//  static func loadData(for user: String) -> [Challenge] {
//    var challenges: [Challenge]?
//    let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
//    //3
//    let predicate = NSPredicate(format: "user = %@", user)
//      fetchRequest.predicate = predicate
//  
//    do {
//      challenges = try managedContext?.fetch(fetchRequest)
//    } catch let error as NSError {
//      print("Could not fetch. \(error), \(error.userInfo)")
//      return []
//    }
//    
//    return challenges!
//  }
//  
//  static func loadSuccessChallengesCount(for user: String) -> Int {
//   
//    var result = 0
//    let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
//    //3
//    let statePredicate = NSPredicate(format: "isDone == %@", NSNumber(value: true))
//    let userPredicate = NSPredicate(format: "user = %@", user)
//    let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [statePredicate, userPredicate])
//    fetchRequest.predicate = predicate
//    
//    do {
//      guard let challenges = try managedContext?.fetch(fetchRequest) else { return 0}
//      result = challenges.count
//    } catch let error as NSError {
//      print("Could not fetch. \(error), \(error.userInfo)")
//      return 0
//    }
//    
//    return result
//    
//  }
//  static func loadData(for user: String) -> [Mood] {
//    var challenges: [Mood]?
//    let fetchRequest: NSFetchRequest<Mood> = Mood.fetchRequest()
//    //3
//    let predicate = NSPredicate(format: "user = %@", user)
//    fetchRequest.predicate = predicate
//    let sort = NSSortDescriptor(key: #keyPath(Mood.date), ascending: true)
//    fetchRequest.sortDescriptors = [sort]
//    do {
//      challenges = try managedContext?.fetch(fetchRequest)
//    } catch let error as NSError {
//      print("Could not fetch. \(error), \(error.userInfo)")
//      return []
//    }
//    
//    return challenges!
//  }
//  
//  static func resetCoreDataStack(for user : String) {
//    var challenges: [Challenge] = loadData(for: user)
//    for challenge in challenges {
//      delete(challenge)
//    }
//    let moods: [Mood] = loadData(for: user)
//    for mood in moods {
//      delete(mood)
//    }
//    save()
//    challenges = loadData(for: user)
//    print(challenges)
//  }
//  
//  static func delete(_ object: NSManagedObject) {
//    managedContext?.delete(object)
//    do { //3
//      try managedContext?.save()
//       print("delete")
//    } catch let error as NSError {
//      print("Saving error: \(error) description: \(error.userInfo)")
//    }
//  }
//  
//  static func deleteMood(_ object: Mood) {
//    managedContext?.delete(object)
//    do { //3
//      try managedContext?.save()
//      print("mood deleted")
//    } catch let error as NSError {
//      print("Saving error: \(error) description: \(error.userInfo)")
//    }
//  }
//  
//  static func save() {
//    // save
//    do {
//      try managedContext?.save()
//    } catch let error {
//      print(error.localizedDescription)
//    }
//    
//  }
//}
