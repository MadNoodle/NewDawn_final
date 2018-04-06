///**
/**
 NewDawn
 Created by: Mathieu Janneau on 05/04/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit

extension MyChallengesViewController {

  
  // MARK: - HEADER METHODS
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    headerSetup(section, view, tableView)
    return view
  }
  
  fileprivate func headerSetup(_ section: Int, _ view: UIView, _ tableView: UITableView) {
    let greenCircle = UIImageView()
    greenCircle.image = #imageLiteral(resourceName: "circle_green")
    
    let titleLabel = UILabel()
    titleLabel.frame = CGRect(x: 40, y: 0, width: 100, height: 30)
    titleLabel.text = sections[section]
    titleLabel.textColor = .black
    titleLabel.font = UIFont(name: UIConfig.lightFont, size: 18.0)
    
    let divider = UIView()
    divider.backgroundColor = UIColor(white: 0, alpha: 0.3)
    view.addSubview(divider)
    view.addSubview(titleLabel)
    view.addSubview(greenCircle)
    divider.frame = CGRect(x: 8, y: 29, width: tableView.frame.width - 16, height: 1)
    greenCircle.frame = CGRect(x: 16, y: 7.5, width: 15, height: 15)
  }
  
   // MARK: - SECTIONS AND ROWS
  override func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return mockData.count
  }
  
  // MARK: - CELL DATA
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? ChallengeDetailCell
    let currentChallenge = mockData[indexPath.row]
    
    cell?.dateLabel.text = currentChallenge.date
    
    if currentChallenge.state {
      cell?.statusIndicator.image = UIImage(named: "circle_green")
    } else {
      cell?.statusIndicator.image = UIImage(named: "circle")
    }
    cell?.titleLabel.text = currentChallenge.title
    
    return cell!
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let currentChallenge = mockData[indexPath.row]
    // instantiate progress controller
    let progressVc = ProgressViewController(nibName: nil, bundle: nil)
    // pass data to the controller
    progressVc.challenge = currentChallenge
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
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    let done = UITableViewRowAction(style: .normal, title: "Done") { action, index in
      self.mockData[indexPath.row].state = true
      tableView.reloadData()
    }
    done.backgroundColor = UIConfig.darkGreen
    
    let postPone = UITableViewRowAction(style: .normal, title: "Postpone") { action, index in
      self.currentCell = indexPath.row
      print(indexPath)
      print(self.currentCell)
      self.postPoneLauncher.showSettings()
    }
    postPone.backgroundColor = UIConfig.lightGreen
    
    let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
      self.mockData.remove(at: indexPath.row)
      tableView.reloadData()
    }
    delete.backgroundColor = .red
    
    return [delete, postPone, done]
  }
  

}
