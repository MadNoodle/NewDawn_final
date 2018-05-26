///**
/**
 NewDawn
 Created by: Mathieu Janneau on 27/03/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit

class ChallengeController: UIViewController {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  let window = UIApplication.shared.keyWindow
  var data = [String]()
  weak var delegate: ChallengeControllerDelegate?
  var category: String = ""
  let reuseId = "myCell"
 
  private var divider: UIView = {
    let view = UIView()
    view.backgroundColor = UIConfig.lightGreen
    return view
  }()

  // ////////////////// //
  // MARK: - OUTLETS    //
  // ////////////////// //
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var titleLabel: UILabel!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // receive data from objective controller
      data = ChallengeList.getChallenges(for: category)
      titleLabel.text = category
    
    
    // Setup views
    shouldDisplayUI()
    shouldDisplayTableView()
  }
  
  // ////////////////// //
  // MARK: - METHODS    //
  // ////////////////// //
  
  private func shouldDisplayTableView() {
    // declare cell
    tableView.register(UINib(nibName: "ChallengeTwo", bundle: nil), forCellReuseIdentifier: reuseId)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.reloadData()
  }
  
  private func shouldDisplayUI() {
    self.navigationController?.navigationBar.tintColor = .white
    titleLabel.addSubview(divider)
    divider.frame = CGRect(x: 0, y: titleLabel.frame.height - 2, width: titleLabel.frame.width + 50, height: 1)
  }
  
}
