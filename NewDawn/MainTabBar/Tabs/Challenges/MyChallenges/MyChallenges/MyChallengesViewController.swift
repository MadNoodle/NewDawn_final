///**
/**
 NewDawn
 Created by: Mathieu Janneau on 30/03/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit
import CoreData
import Firebase
import FirebaseDatabase

/// TableView Controller that presents all the current challenge for the user
/// It allows the user to add new challenges
class MyChallengesViewController: UITableViewController, EditableChallenge {
  var challengeKey: String?
  
  var challengeToSend: TempChallenge?

  
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  var currentUser = ""
  var data: [TempChallenge] = []
//  var firebaseService = FirebaseService()
//  var databaseRef: DatabaseReference!
  
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
    
    DatabaseService.shared.challengeRef.observe(.value) { (snapshot) in
      var newItems = [TempChallenge]()
      for item in snapshot.children {
       
        let newChallenge = TempChallenge(snapshot: item as! DataSnapshot)
        print("KEY:\(newChallenge.key!)")
        newItems.insert(newChallenge, at: 0)
      }
      for item in newItems where item.user == self.currentUser {
        self.data.insert(item, at: 0)
      }
      self.tableView.reloadData()
    }


   
    let rightButton: UIBarButtonItem = UIBarButtonItem(
                                  barButtonSystemItem: .add,
                                  target: self,
                                  action: #selector(addChallenge))
    self.navigationItem.rightBarButtonItem = rightButton
    tableView.register(UINib(nibName: "ChallengeDetailCell", bundle: nil), forCellReuseIdentifier: reuseId)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(didUpdateDate(notif:)), name: NSNotification.Name(rawValue: "DateValueChanged"),
                                           object: nil)
  }
  
  @objc func addChallenge() {
    let objectiveVc = ObjectiveViewController(nibName: nil, bundle: nil)
    self.navigationController?.pushViewController(objectiveVc, animated: true)
  }
  
  @objc func didUpdateDate(notif: NSNotification) {
//    if let cell = currentCell {
//   let currentChallenge = self.fetchedResultsController.object(at: cell)
//    
//    let date = (notif.userInfo?["Date"] as? Date)!.timeIntervalSince1970
//    currentChallenge.dueDate = date
//  
//    tableView.reloadData()
//      
//    }
  }
}
