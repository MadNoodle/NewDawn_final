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
  
  var challengeToSend: Challenge?

  
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  var currentUser = ""
  var data: [Challenge] = []
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
      var newItems = [Challenge]()
      for item in snapshot.children {
       
        let newChallenge = Challenge(snapshot: item as! DataSnapshot)
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
  

  override func viewWillDisappear(_ animated: Bool) {
    self.data.removeAll()
  }
  
  @objc func addChallenge() {
    let objectiveVc = ObjectiveViewController(nibName: nil, bundle: nil)
    self.navigationController?.pushViewController(objectiveVc, animated: true)
  }
  
}
