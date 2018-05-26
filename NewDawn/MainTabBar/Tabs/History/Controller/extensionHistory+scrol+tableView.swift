///**
/**
NewDawn
Created by: Mathieu Janneau on 26/05/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import UIKit

extension HistoryViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Y coordinates to reload animation when scroll
    let trigger = progressCircle.frame.midY - barChart.frame.maxY
    
    // trigger circle animation when progress circle is revealed
    if scrollView.contentOffset.y >= trigger {
      loadDataCircle()
    }
  }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return history.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? ChallengeDetailCell
    let currentChallenge = history[indexPath.row]
    cell?.titleLabel.text = currentChallenge.name
    
    let date = Date(timeIntervalSince1970: (currentChallenge.dueDate)!)
    cell?.dateLabel.text = date.convertToString(format: .dayHourMinute)
    
    
    if currentChallenge.isDone == 1 {
      cell?.statusIndicator.image = UIImage(named: "Path")
    } else {
      cell?.statusIndicator.image = UIImage(named: "circle_green")
    }
    
    return cell!
  }
  
  
}
