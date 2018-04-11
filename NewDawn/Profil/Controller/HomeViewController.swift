//
//  HomeViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.

// swiftlint:disable trailing_whitespace

import UIKit

class HomeViewController: UIViewController {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  let mockData = MockChallenge.getMockChallenges()
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
    for button in moodButtons {
      button.typeOfButton = .imageButton
    }
   
    challengesTableView.delegate = self
    challengesTableView.dataSource = self
    challengesTableView.register(UINib(nibName: "ChallengeCell", bundle: nil), forCellReuseIdentifier: reuseId)
  }
  
  // ////////////////// //
  // MARK: - ACTIONS    //
  // ////////////////// //
  
  @IBAction func moodButtonTapped(_ sender: CustomUIButtonForUIToolbar) {
    evaluateMoodButtonState()
    sender.userDidSelect()
    // ToDo: Store selected state in BDD
  }
  
  fileprivate func evaluateMoodButtonState() {
    for moodButton in moodButtons where moodButton.choosen {  
        moodButton.reset()
    }
  }
  
}


