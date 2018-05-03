///**
/**
 NewDawn
 Created by: Mathieu Janneau on 05/04/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit
import Firebase
import FirebaseDatabase

extension MyChallengesViewController {
  

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  // MARK: - CELL DATA
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? ChallengeDetailCell
   
    let currentChallenge = data[indexPath.row]
     cell?.titleLabel.text = currentChallenge.name
    let date = Date(timeIntervalSince1970: currentChallenge.dueDate)
    cell?.dateLabel.text = date.convertToString(format: .dayHourMinute)
    print(currentChallenge)
    
    if currentChallenge.isDone == 1 {
      cell?.statusIndicator.image = UIImage(named: "circle_green")
    } else {
      cell?.statusIndicator.image = UIImage(named: "circle")
    }
   
      
    
    
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    let currentChallenge = data[indexPath.row]
    // instantiate progress controller
    let progressVc = ProgressViewController(nibName: nil, bundle: nil)
    // pass data to the controller
    progressVc.challenge = currentChallenge
    challengeKey = currentChallenge.key
    progressVc.challengeKey = challengeKey
    // present controller
    self.navigationController?.pushViewController(progressVc, animated: true)
  }
  
  // MARK: - CELL DISPLAY
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  // MARK: - SLIDE OPTIONS
  

  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    // Done action
    let done = UITableViewRowAction(style: .normal, title: "Done") { _, _ in
      let updatedChallenge = ["isdone": true]
      // remove cell
      self.data.remove(at: indexPath.row)
      
      // update DB
      let ref = self.data[indexPath.row].ref
      ref?.updateChildValues(updatedChallenge, withCompletionBlock: { (error, ref) in
        if error != nil {
          print(error!.localizedDescription)
        }
        // update table
        self.tableView.reloadData()
      })
    }
    done.backgroundColor = UIConfig.darkGreen
    
    let delete = UITableViewRowAction(style: .normal, title: "Delete") { _, _ in
     let ref = self.data[indexPath.row].ref
      ref?.removeValue(completionBlock: { (error, ref) in
        if error != nil {
          print(error!.localizedDescription)
        }
        self.data.remove(at: indexPath.row)
         self.tableView.deleteRows(at: [indexPath], with: .automatic)
      })
        
      
      
        
    
      
    }
    delete.backgroundColor = .red
    
    return [delete, done]
  }
  
  fileprivate func updateCellChallenge(_ currentChallenge: TempChallenge) {
    
   
  }
}
