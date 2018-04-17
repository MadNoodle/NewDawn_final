//
//  HomeViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.

// swiftlint:disable trailing_whitespace

import UIKit

/// Profil view controller which displays a user summary
/// and let him access to his personnal data
class HomeViewController: UIViewController {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  let mockData = MockChallenge.getMockChallenges()
  /// Reuse id for challenge table view cells
  let reuseId = "myCell"
  
  // ////////////////// //
  // MARK: - OUTLETS    //
  // ////////////////// //
  
  @IBOutlet var moodButtons: [CustomUIButtonForUIToolbar]!
  @IBOutlet weak var challengesTableView: UITableView!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // set up of mood button color behavior on tap
    for button in moodButtons {
      button.typeOfButton = .imageButton
    }
    // set up delegation
    challengesTableView.delegate = self
    challengesTableView.dataSource = self
    challengesTableView.register(UINib(nibName: "ChallengeCell", bundle: nil), forCellReuseIdentifier: reuseId)
  }
  
  // ////////////////// //
  // MARK: - ACTIONS    //
  // ////////////////// //
  
  /// handle the color display behavior when user tap a button
  ///
  /// - Parameter sender: CustomUIButtonForUIToolbar
  @IBAction func moodButtonTapped(_ sender: CustomUIButtonForUIToolbar) {
    evaluateMoodButtonState()
    sender.userDidSelect()
    // ToDo: Store selected state in BDD
  }
  
  /// Iterate throught all mood buttons state and reset to
  /// initial color to allow user to to color the last selected Mood
  fileprivate func evaluateMoodButtonState() {
    for moodButton in moodButtons where moodButton.choosen {  
      moodButton.reset()
    }
  }
  
}
