///**
/**
NewDawn
Created by: Mathieu Janneau on 30/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit

extension ChallengeController : UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? ChallengeTwo
    cell?.challengeTitle.text = data[indexPath.row]
    

    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    cellTitle = data[indexPath.row]
    print("titre step1 :\(cellTitle!)")
    
    let addVc = CreateChallengeViewController()
    addVc.delegate = self
    
    self.navigationController?.pushViewController(addVc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {return}
    cell.contentView.backgroundColor = UIConfig.lightGreen
    cell.textLabel?.textColor = .white

  }
}
