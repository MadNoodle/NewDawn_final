//
//  HomeViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.

// swiftlint:disable trailing_whitespace

import UIKit

/// Profil view controller which displays a user summary
/// and let him access to his personnal data
class HomeViewController: UIViewController {
  var currentUser = ""
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  var data = [Challenge]()
  // let mockData = MockChallenge.getMockChallenges()
  /// Reuse id for challenge table view cells
  let reuseId = "myCell"
  let calenderView: CalenderView = {
    let v = CalenderView(theme: MyTheme.light)
    v.translatesAutoresizingMaskIntoConstraints=false
    return v
  }()
  // ////////////////// //
  // MARK: - OUTLETS    //
  // ////////////////// //
  
  @IBOutlet var moodButtons: [CustomUIButtonForUIToolbar]!
//  @IBOutlet weak var challengesTableView: UITableView!
  
  @IBOutlet weak var calendarContainer: UIView!
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //

  

  
  override func viewDidLoad() {

    super.viewDidLoad()
    shouldDisplayCalendarView()
    shouldDisplayPlusButton()
    NotificationCenter.default.addObserver(self, selector:#selector(addChallenge), name: NSNotification.Name(rawValue: "calendarActive"), object: nil)
    data = CoreDataService.loadData(for: currentUser)
    // set up of mood button color behavior on tap
    for button in moodButtons {
      button.typeOfButton = .imageButton
    }
  }
  
  @objc func addChallenge() {
    let alert = UIAlertController(title: "Add a New Challenge", message: "", preferredStyle: .actionSheet) // 1
    let firstAction = UIAlertAction(title: "New Challenge", style: .default) { (alert: UIAlertAction!) -> Void in
      let objVc = ObjectiveViewController()
      // Renvoyer la date
      self.navigationController?.pushViewController(objVc, animated: true)
    } // 2
    
    let secondAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) -> Void in
      NSLog("You pressed button two")
    } // 3
    
    alert.addAction(firstAction) // 4
    alert.addAction(secondAction) // 5
    present(alert, animated: true, completion:nil) // 6
  }
  
  fileprivate func shouldDisplayPlusButton() {
    let rightButton: UIBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addChallenge))
    self.navigationItem.rightBarButtonItem = rightButton
    if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
      currentUser = user
    }
  }
  
  fileprivate func shouldDisplayCalendarView() {
    calendarContainer.addSubview(calenderView)
    calenderView.topAnchor.constraint(equalTo: calendarContainer.topAnchor, constant: 0).isActive = true
    calenderView.rightAnchor.constraint(equalTo: calendarContainer.rightAnchor, constant: 0).isActive=true
    calenderView.leftAnchor.constraint(equalTo: calendarContainer.leftAnchor, constant: 0).isActive=true
    calenderView.heightAnchor.constraint(equalToConstant: calendarContainer.frame.height).isActive=true
  }
  // ////////////////// //
  // MARK: - ACTIONS    //
  // ////////////////// //
  
  /// handle the color display behavior when user tap a button
  ///
  /// - Parameter sender: CustomUIButtonForUIToolbar
  @IBAction func moodButtonTapped(_ sender: CustomUIButtonForUIToolbar) {
    evaluateMoodButtonState()

    CoreDataService.saveMood(user: currentUser, date: Date(), value: sender.tag)
    sender.userDidSelect()
    // ToDo: Store selected state in BDD
  }
  
  /// Iterate throught all mood buttons state and reset to
  /// initial color to allow user to to color the last selected Mood
  fileprivate func evaluateMoodButtonState() {
    for moodButton in moodButtons where moodButton.choosen {  
      moodButton.reset()
    }
  }
  
}
