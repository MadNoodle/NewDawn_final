//
//  HomeViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.

// swiftlint:disable trailing_whitespace

import UIKit

class HomeViewController: UIViewController {
  let mockData = MockChallenge.getMockChallenges()
  let reuseId = "myCell"
  @IBOutlet var moodButtons: [CustomUIButtonForUIToolbar]!
  
  @IBOutlet weak var challengesTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Profil"
    challengesTableView.delegate = self
    challengesTableView.dataSource = self
    challengesTableView.register(UINib(nibName: "ChallengeCell", bundle: nil), forCellReuseIdentifier: reuseId)
  }
  
  @IBAction func moodButtonTapped(_ sender: CustomUIButtonForUIToolbar) {
    evaluateMoodButtonState()
    sender.userDidSelect()
    // ToDo: Store selected state in BDD
  }
  
  fileprivate func evaluateMoodButtonState() {
    for moodButton in moodButtons where moodButton.choosen {  
        moodButton.resetImage()
    }
  }
  
}


