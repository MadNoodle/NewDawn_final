//
//  HomeViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  let mockData = MockChallenge.getMockChallenges()
  @IBOutlet var moodButtons: [CustomUIButtonForUIToolbar]!
  
  @IBOutlet weak var challengesTableView: UITableView!
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Profil"
    challengesTableView.delegate = self
    challengesTableView.dataSource = self
    challengesTableView.register(UINib(nibName:"ChallengeCell",bundle: nil), forCellReuseIdentifier: "myCell")
  }
  
  @IBAction func moodButtonTapped(_ sender: CustomUIButtonForUIToolbar) {
    evaluateMoodButtonState()
    sender.userDidSelect()
    // ToDo: Store selected state in BDD
  }
  
  fileprivate func evaluateMoodButtonState() {
    for moodButton in moodButtons {
      if moodButton.choosen {
        moodButton.resetImage()
      }
    }
  }
  
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return mockData.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? ChallengeCell
    let currentChallenge = mockData[indexPath.row]
    cell?.challengeTime.text = currentChallenge.date
    if currentChallenge.state {
      cell?.challengeState.image = UIImage(named: "circle_green")
    } else{
      cell?.challengeState.image = UIImage(named: "circle")
    }
    cell?.challengeDescription.text = currentChallenge.title
    cell?.objectiveIcon.image = UIImage(named:currentChallenge.icon)
    
    return cell!
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("Selected cell : \(mockData[indexPath.row].title)")
  }
  //Todo: userSelectRow action
}
