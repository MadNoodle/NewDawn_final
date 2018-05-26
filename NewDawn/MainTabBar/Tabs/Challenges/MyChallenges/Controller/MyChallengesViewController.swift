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
  let sections: [String] = [NSLocalizedString("Drive", comment: ""), NSLocalizedString("Walk", comment: ""), NSLocalizedString("Party", comment: ""), NSLocalizedString("Travel", comment: ""), NSLocalizedString("Custom", comment: "")]
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
      // sort newest first
      self.data = self.data.sorted(by: {$0.dueDate > $1.dueDate})
      // Show only upcoming
      let today = Date().timeIntervalSince1970
      self.data = self.data.filter({$0.dueDate > today})
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
