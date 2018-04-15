///**
/**
 NewDawn
 Created by: Mathieu Janneau on 30/03/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit
import CoreData

class MyChallengesViewController: UITableViewController{
 
  let postPoneLauncher = PostPoneLauncher()
  var mockData = MockChallenge.getMockChallenges()
  let reuseId = "myCell"
  let sections: [String] = ["Drive","Walk","Party","Travel"]
  var currentCell:Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
   
    let rightButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChallenge))
    self.navigationItem.rightBarButtonItem = rightButton
    tableView.register(UINib(nibName: "ChallengeDetailCell", bundle: nil), forCellReuseIdentifier: reuseId)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(self, selector: #selector(didUpdateDate(notif:)), name: NSNotification.Name(rawValue: "DateValueChanged"), object: nil)
  }
  @objc func addChallenge(){
    let objectiveVc = ObjectiveViewController(nibName:nil,bundle:nil)
    self.navigationController?.pushViewController(objectiveVc, animated: true)
  }
  
  @objc func didUpdateDate(notif:NSNotification){
    print ("received notification")
    print(currentCell)
    // receive data from Picker
    
    var currentChallenge = mockData[currentCell]
    
   currentChallenge.date = notif.userInfo?["Date"] as! Date
  
   
    tableView.reloadData()
  }
  

}




