///**
/**
 NewDawn
 Created by: Mathieu Janneau on 27/03/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit

class ChallengeController: UIViewController {
  
  let window = UIApplication.shared.keyWindow
  var data = [String]()
  var delegate: ChallengeControllerDelegate?
  var category : ChallengeType?
  let reuseId = "myCell"
  
  var header: UIView = {
    let headerView = UIView()
    headerView.backgroundColor = .white
    return headerView
  }()
  
  var divider: UIView = {
    let view = UIView()
    view.backgroundColor = UIConfig.lightGreen
    return view
  }()
  
  var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: UIConfig.semiBoldFont, size: 26.0)
    return label
  }()
  
  var tableView: UITableView = {
    let table = UITableView()
    return table
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // receive data from objecctive controller
    if let category = delegate?.sendCategory() {
      data = ChallengeList.getChallenges(for: category)
      titleLabel.text = category.rawValue
    }
    // Setup views
    setupUI()
    tableViewSetup()
  }
  
  fileprivate func tableViewSetup() {
    // declare cell
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.reloadData()
  }
  
  func setupUI(){
    self.navigationController?.navigationBar.tintColor = .white
    view.addSubview(header)
    header.frame = CGRect(x: 0, y: 85, width: self.view.frame.width, height: 50)
    header.addSubview(divider)
    divider.frame = CGRect(x: 16, y: header.frame.height - 2, width: header.frame.width - 32, height: 1)
    view.addSubview(tableView)
    tableView.frame = CGRect(x: 0, y: 85 + header.frame.height, width: self.view.frame.width, height: self.view.frame.height)
    header.addSubview(titleLabel)
    titleLabel.frame = CGRect(x: 16, y: header.frame.height - 32, width: header.frame.width - 32, height: 21)
  }
}


