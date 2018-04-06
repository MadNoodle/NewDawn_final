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
 
  
  
  private var divider: UIView = {
    let view = UIView()
    view.backgroundColor = UIConfig.lightGreen
    return view
  }()

  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var titleLabel: UILabel!
  
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
  
  private func tableViewSetup() {
    // declare cell
    tableView.register(UINib(nibName: "ChallengeTwo",bundle: nil), forCellReuseIdentifier: reuseId)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.reloadData()
  }
  
  private func setupUI(){
    self.navigationController?.navigationBar.tintColor = .white
    titleLabel.addSubview(divider)
    divider.frame = CGRect(x: 0, y: titleLabel.frame.height - 2, width: titleLabel.frame.width + 50, height: 1)
  }
  

}


