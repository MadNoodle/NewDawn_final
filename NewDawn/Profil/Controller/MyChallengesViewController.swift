///**
/**
NewDawn
Created by: Mathieu Janneau on 30/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit

class MyChallengesViewController: UITableViewController {
  var mockData = MockChallenge.getMockChallenges()
  let reuseId = "myCell"
  
    override func viewDidLoad() {
        super.viewDidLoad()
      let rightButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChallenge))
      self.navigationItem.rightBarButtonItem = rightButton
        tableView.register(UINib(nibName: "ChallengeCell", bundle: nil), forCellReuseIdentifier: reuseId)
    }

  @objc func addChallenge(){
    let objectiveVc = ObjectiveViewController(nibName:nil,bundle:nil)
    self.navigationController?.pushViewController(objectiveVc, animated: true)
  }
    // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return mockData.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? ChallengeCell
    let currentChallenge = mockData[indexPath.row]
    cell?.challengeTime.text = currentChallenge.date
    if currentChallenge.state {
      cell?.challengeState.image = UIImage(named: "circle_green")
    } else {
      cell?.challengeState.image = UIImage(named: "circle")
    }
    cell?.challengeDescription.text = currentChallenge.title
    cell?.objectiveIcon.image = UIImage(named: currentChallenge.icon)
    
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    let done = UITableViewRowAction(style: .normal, title: "Done") { action, index in
      self.mockData[indexPath.row].state = true
      tableView.reloadData()
    }
    done.backgroundColor = UIColor.lightGray
    
    let postPone = UITableViewRowAction(style: .normal, title: "Postpone") { action, index in
    }
    postPone.backgroundColor = UIColor.orange
    
    let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
      self.mockData.remove(at: indexPath.row)
      tableView.reloadData()
    }
    delete.backgroundColor = .red
    
    return [delete, postPone, done]
  }
}
