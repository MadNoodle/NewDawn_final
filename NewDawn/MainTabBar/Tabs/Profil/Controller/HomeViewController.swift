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
    
    //self.calendarView.reloadData()
  }
  

  
  override func viewWillAppear(_ animated: Bool) {
    loadDataInCalendar()
  }
  
  // ////////////////// //
  // MARK: - UI         //
  // ////////////////// //
  
  fileprivate func shouldDisplayUI() {
    
    // set up of mood button color behavior on tap
    for button in moodButtons {
      button.typeOfButton = .imageButton
    }
    
    let rightButton: UIBarButtonItem =  UIBarButtonItem(title: "add challenge",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(addChallenge))
    self.navigationItem.rightBarButtonItem = rightButton
    setupCalendarView()
  }
  
  fileprivate func loadDataInCalendar() {
    DispatchQueue.main.async {
      DatabaseService.shared.loadEventsDatabase(for: self.currentUser) { result in
        guard let eventDates = result else { return}
        self.events = eventDates
        self.calendarView.reloadData()
      }
    }
  }
  func setupCalendarView() {
    // register cell
    let nib = UINib(nibName: "CalendarCell", bundle: nil)
    let headerNib = UINib(nibName: "headerView", bundle: nil)
    calendarView.register(nib, forCellWithReuseIdentifier: UIConfig.calendarCellId)
    calendarView.register(headerNib, forSupplementaryViewOfKind: UIConfig.calendarHeaderId, withReuseIdentifier: UIConfig.calendarHeaderId)
    // UI appearance settings
    calendarView.minimumLineSpacing = 0
    calendarView.minimumInteritemSpacing = 0
    calendarView.backgroundColor = .clear
    // delegation attribution
    calendarView.ibCalendarDelegate = self
    calendarView.ibCalendarDataSource = self
    calendarView.isScrollEnabled = false
    calendarView.scrollToDate(Date(), animateScroll: false)
    calendarView.selectDates([Date()])
    self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
      self.setupViewsOfCalendar(from: visibleDates)
    }
    
  }
  
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
  func showChallenge() {
    if let challengeToPresent = selectedChallenge {
      let challengeVc = ProgressViewController()
      // TODO: - delegation??
      challengeVc.challenge = challengeToPresent
      self.navigationController?.pushViewController(challengeVc, animated: true)
    }
    
  }
  
  @objc func addChallenge() {
    let alert = UIAlertController(title: LocalisationString.addAlert, message: LocalisationString.messageAlert, preferredStyle: .actionSheet)
    let firstAction = UIAlertAction(title: LocalisationString.newChallengeAlert, style: .default) { (_) -> Void in
      let objVc = ObjectiveViewController()
      // Renvoyer la date
      self.navigationController?.pushViewController(objVc, animated: true)
    } // 2
    
    let secondAction = UIAlertAction(title: LocalisationString.ErrorTitles.cancel.rawValue, style: .default) { (_) -> Void in
      NSLog("You pressed button two")
    }
    
    alert.addAction(firstAction)
    alert.addAction(secondAction)
    present(alert, animated: true, completion: nil)
  }
  
}
