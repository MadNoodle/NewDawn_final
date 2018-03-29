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
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
    cell.textLabel?.text = data[indexPath.row]
    cell.textLabel?.font = UIFont(name: UIConfig.lightFont, size: 15.0)
    
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "plus "), for: .normal)
    cell.addSubview(button)
    let size: CGFloat = 13
    button.frame = CGRect(x: cell.frame.width - size , y: (cell.frame.height / 2) - (size / 2), width: size, height: size)
    
    return cell
  }
}
