///**
/**
NewDawn
Created by: Mathieu Janneau on 30/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return mockData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // Define custom cell
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? ChallengeCell
    
    // Data for cell
    let currentChallenge = mockData[indexPath.row]
    
    cell?.challengeTime.text = currentChallenge.date
    
    // Change cell status image according to challenge completion or not
    if currentChallenge.state {
      cell?.challengeState.image = UIImage(named: "circle_green")
    } else {
      cell?.challengeState.image = UIImage(named: "circle")
    }
    // Challenge title
    cell?.challengeDescription.text = currentChallenge.title
    // Challenge Category image
    cell?.objectiveIcon.image = UIImage(named: currentChallenge.icon)
    
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
