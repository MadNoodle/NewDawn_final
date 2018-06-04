//
//  HomeViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.

// swiftlint:disable trailing_whitespace

import UIKit
import JTAppleCalendar
import Firebase

/// Profil view controller which displays a user summary
/// and let him access to his personnal data
class HomeViewController: UIViewController {
  var currentUser = ""
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  /// Array that allows to store and retrieve data from firebase and display it
  var data: [Challenge] = []
  /// Property that stores a challenge associated with a date
  var selectedChallenge: Challenge?
  /// Reuse id for challenge table view cells
  let reuseId = "myCell"
  /// date formatter
  let dateFormatter = DateFormatter()
  var iii: Date?
  /// Array that allows to store and retrieve the dates of every stored challenge
  open var events: [String] = []
  
  // ////////////////// //
  // MARK: - OUTLETS    //
  // ////////////////// //
  
  @IBOutlet var moodButtons: [CustomUIButtonForUIToolbar]!
  @IBOutlet weak var calendarView: JTAppleCalendarView!
  @IBOutlet weak var montDisplay: UILabel!
  @IBOutlet weak var todaysMoodLabel: UILabel!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    // load logged user
    if let user = UserDefaults.standard.object(forKey: UIConfig.currentUserKey) as? String {
      currentUser = user
    }
    
    // set up notification observers
    handleNotifications()
    loadDataInCalendar()
    shouldDisplayUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    loadDataInCalendar()
  }
  
  // ////////////////// //
  // MARK: - UI         //
  // ////////////////// //
  
  /// Present and in stantiate all UI Elements
  fileprivate func shouldDisplayUI() {
    
    todaysMoodLabel.text = NSLocalizedString("todayMood", comment: "")
    // set up of mood button color behavior on tap
    for button in moodButtons {
      button.typeOfButton = .imageButton
    }
    // Addd navigationBar buttons
    let rightButton: UIBarButtonItem =  UIBarButtonItem(title: NSLocalizedString("add challenge", comment: ""),
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(addChallenge))
    self.navigationItem.rightBarButtonItem = rightButton
    setupCalendarView()
  }
  
  /// Load all challenges date in the calendar
  fileprivate func loadDataInCalendar() {
    DispatchQueue.main.async {
      DatabaseService.shared.loadEventsDatabase(for: self.currentUser) { result in
        guard let eventDates = result else { return}
        self.events = eventDates
        self.calendarView.reloadData()
      }
    }
  }
  
  /// Observer that catch if a new challenge is added and modify calendar according to it
  fileprivate func handleNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(addChallenge),
                                           name: NSNotification.Name(rawValue: "calendarActive"),
                                           object: nil)
  }
  
  // ////////////////// //
  // MARK: - ACTIONS    //
  // ////////////////// //
  
  /// handle the color display behavior when user tap a button
  ///
  /// - Parameter sender: CustomUIButtonForUIToolbar
  @IBAction func moodButtonTapped(_ sender: CustomUIButtonForUIToolbar) {
    // check if a button is already seleccted and reset all buttons to initial state before new selection
    evaluateMoodButtonState()
    // save selected mood to database
    DatabaseService.shared.saveMood(user: currentUser, state: sender.tag, date: Date().timeIntervalSince1970, onCompleted: { status in
      print(status)
    })
    // change the appeance of selected button
    sender.userDidSelect()
  }
  
  @IBAction func previousMonth(_ sender: UIButton) {
    calendarView.scrollToSegment(.previous)
    calendarView.reloadData()
  }
  @IBAction func nextMonth(_ sender: UIButton) {
    calendarView.scrollToSegment(.next)
    calendarView.reloadData()
  }
  
  /// Iterate throught all mood buttons state and reset to
  /// initial color to allow user to to color the last selected Mood
  fileprivate func evaluateMoodButtonState() {
    for moodButton in moodButtons where moodButton.choosen {  
      moodButton.reset()
    }
  }
  
  // ////////////////// //
  // MARK: - SELECTORS  //
  // ////////////////// //
  
  /// Display Detail view for challenge associated with a date
  func showChallenge() {
    if let challengeToPresent = selectedChallenge {
      let challengeVc = ProgressViewController()
      challengeVc.challenge = challengeToPresent
      self.navigationController?.pushViewController(challengeVc, animated: true)
    }
  }
  
  /// Selector for navigationBar add button that present choices in an Alert Action sheet
  @objc func addChallenge() {
    let alert = UIAlertController(title: NSLocalizedString("Add a New Challenge", comment: ""), message: NSLocalizedString("Empty", comment: ""), preferredStyle: .actionSheet)
    let firstAction = UIAlertAction(title: NSLocalizedString("New Challenge", comment: ""), style: .default) { (_) -> Void in
      let objVc = ObjectiveViewController()
      // Renvoyer la date
      self.navigationController?.pushViewController(objVc, animated: true)
    } // 2
    
    let secondAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { (_) -> Void in
      NSLog("You pressed button two")
    }
    
    alert.addAction(firstAction)
    alert.addAction(secondAction)
    present(alert, animated: true, completion: nil)
  }
  
}
