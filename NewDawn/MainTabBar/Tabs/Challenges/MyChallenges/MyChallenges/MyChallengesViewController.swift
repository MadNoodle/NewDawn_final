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
    // load current user 
    if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
      currentUser = user    
    }
    
    shouldLoadTableView()
    shouldDisplayNavBarItems()
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.data.removeAll()
  }
  
  @objc func addChallenge() {
    let objectiveVc = ObjectiveViewController(nibName: nil, bundle: nil)
    self.navigationController?.pushViewController(objectiveVc, animated: true)
  }
  
  
  
  fileprivate func shouldLoadTableView() {
    tableView.register(UINib(nibName: "ChallengeDetailCell", bundle: nil), forCellReuseIdentifier: reuseId)
    // Load challenges for user from firebase
    DatabaseService.shared.loadChallenges(for: currentUser) { (challengeArray) in
    
      guard let loadedChallenges = challengeArray else { return}
      self.data = loadedChallenges
      self.tableView.reloadData()
    }
  }
  
  fileprivate func shouldDisplayNavBarItems() {
    let rightButton: UIBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addChallenge))
    self.navigationItem.rightBarButtonItem = rightButton
  }
  
}
