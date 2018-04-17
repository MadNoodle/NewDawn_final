///**
/**
 NewDawn
 Created by: Mathieu Janneau on 16/04/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import Foundation
import UIKit
import CoreData

class CoreDataService {
  
  // iniatlize app delegate
  static let appDelegate = UIApplication.shared.delegate as? AppDelegate
  static let managedContext = appDelegate?.persistentContainer.viewContext
  
  static func saveUser(lastName: String, firstName: String, email: String, password: String) {
    
    // Create entity
    let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext!)
    let user = NSManagedObject(entity: entity!,
                               insertInto: managedContext)
    user.setValue(lastName, forKey: "lastName")
    user.setValue(firstName, forKey: "firstName")
    user.setValue(email, forKey: "email")
    user.setValue(password, forKey: "password")
    
    save()
    print(user)
  }
  
  static func createChallenge(name: String, dueDate: Double, isNotified: Bool, anxietyLevel: Int, benefitLevel: Int, objective: String, location: ChallengeDestination?) {
    
    // Create entity
    
    let challenge = NSEntityDescription.insertNewObject(forEntityName: "Challenge", into: managedContext!) as! Challenge
    challenge.objective = objective
    challenge.name = name
    challenge.dueDate = dueDate
    challenge.isNotified = isNotified
    challenge.anxietyLevel = Int32(anxietyLevel)
    challenge.benefitLevel = Int32(benefitLevel)
    challenge.isDone = false
    if let targetLocation = location {
      print(targetLocation.lat)
      challenge.destination = targetLocation.locationName
      challenge.destinationLat = targetLocation.lat
      challenge.destinationLong = targetLocation.long
    }
    
    save()
 
    print(challenge)
  }
    
  static func saveImage(_ map: UIView) {    
    // Define entity
    let challenge = NSEntityDescription.insertNewObject(forEntityName: "Challenge", into: managedContext!) as! Challenge
    // convert mapView to image
    let screenshot = UIImage(view:map)
    // convert image to data
    let mapImage = UIImagePNGRepresentation(screenshot) as NSData?
    // store in core data
    
      challenge.map = mapImage
      save()
    
    print(challenge)
  }
  
  static func loadData(filter: NSPredicate?) -> [Challenge] {
    var challenges: [Challenge]?
    let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
    //3
    if let predicate = filter {
      fetchRequest.predicate = predicate
  
    do {
      challenges = try managedContext?.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
      return []
    }
    }
    return challenges!
  }
  
  static func delete(_ object: Challenge) {
    managedContext?.delete(object)
    do { //3
      try managedContext?.save()
       print("delete")
    } catch let error as NSError {
      print("Saving error: \(error) description: \(error.userInfo)")
    }
  }
  
  static func save() {
    // save
    do {
      try managedContext?.save()
    } catch let error {
      print(error.localizedDescription)
    }
    
  }
}
