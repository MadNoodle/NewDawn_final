///**
/**
 NewDawn
 Created by: Mathieu Janneau on 30/03/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit
import CoreData

/// TableView Controller that presents all the current challenge for the user
/// It allows the user to add new challenges
class MyChallengesViewController: UITableViewController {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  var currentUser = ""
  var data: [Challenge] = []
  
  lazy var fetchedResultsController: NSFetchedResultsController<Challenge> = {
    // Initialize Fetch Request
    // 1
    let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
    // 2
    
    let sort = NSSortDescriptor(key: #keyPath(Challenge.dueDate),
                                ascending: true)
    fetchRequest.sortDescriptors = [sort]
    
    let statePredicate = NSPredicate(format: "isDone == %@", NSNumber(value: false))
    let userPredicate = NSPredicate(format: "user = %@", currentUser)
    let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [statePredicate, userPredicate])
    
    fetchRequest.predicate = predicate
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: CoreDataService.managedContext!,
      sectionNameKeyPath: #keyPath(Challenge.objective),
      cacheName: "challengeStack")
    // Configure Fetched Results Controller
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
  let postPoneLauncher = PostPoneLauncher()
  let reuseId = "myCell"
  /// Objective category
  let sections: [String] = ["Drive", "Walk", "Party", "Travel"]
  var currentCell: IndexPath?
  
  // ////////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ////////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
      currentUser = user
    }
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
    
   
    let rightButton: UIBarButtonItem = UIBarButtonItem(
                                  barButtonSystemItem: .add,
                                  target: self,
                                  action: #selector(addChallenge))
    self.navigationItem.rightBarButtonItem = rightButton
    tableView.register(UINib(nibName: "ChallengeDetailCell", bundle: nil), forCellReuseIdentifier: reuseId)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(didUpdateDate(notif:)), name: NSNotification.Name(rawValue: "DateValueChanged"),
                                           object: nil)
  }
  
  @objc func addChallenge() {
    let objectiveVc = ObjectiveViewController(nibName: nil, bundle: nil)
    self.navigationController?.pushViewController(objectiveVc, animated: true)
  }
  
  @objc func didUpdateDate(notif: NSNotification) {
    if let cell = currentCell {
   let currentChallenge = self.fetchedResultsController.object(at: cell)
    
    let date = (notif.userInfo?["Date"] as? Date)!.timeIntervalSince1970
    currentChallenge.dueDate = date
  
    tableView.reloadData()
      
    }
  }
}
