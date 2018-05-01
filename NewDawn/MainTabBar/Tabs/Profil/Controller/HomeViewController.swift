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
import FirebaseDatabase
/// Profil view controller which displays a user summary
/// and let him access to his personnal data
class HomeViewController: UIViewController {
  var currentUser = ""
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  var data: [TempChallenge] = []
  var selectedChallenge: TempChallenge?
  /// Reuse id for challenge table view cells
  let reuseId = "myCell"
  let dateFormatter = DateFormatter()
  var iii: Date?
  open var events: [String] = []
  var firebaseService = FirebaseService()
  var databaseRef: DatabaseReference!
  
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
    if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
      currentUser = user
      }
    // set up notification observers
    handleNotifications()
    shouldDisplayUI()
    DispatchQueue.main.async {
      self.databaseRef = Database.database().reference().child("challenges")
      self.databaseRef.observe(.value, with: { (snapshot) in
        var newItems = [TempChallenge]()
        for item in snapshot.children {
          let newChallenge = TempChallenge(snapshot: item as! DataSnapshot)
          newItems.insert(newChallenge, at: 0)
        }
        for item in newItems where item.user == self.currentUser {
          self.data.insert(item, at: 0)
          self.events.insert(self.dateFormatter.string(from: Date(timeIntervalSince1970: item.dueDate!)), at: 0)
        }
        
        print("DATA: \(self.data)")
        
      })
      self.calendarView.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    print("DATA2: \(self.data)")
      databaseRef = Database.database().reference().child("challenges")
      databaseRef.observe(.value, with: { (snapshot) in
        var newItems = [TempChallenge]()
        for item in snapshot.children {
          let newChallenge = TempChallenge(snapshot: item as! DataSnapshot)
          newItems.insert(newChallenge, at: 0)
        }
        for item in newItems where item.user == self.currentUser {
          self.data.insert(item, at: 0)
           self.events.insert(self.dateFormatter.string(from: Date(timeIntervalSince1970: item.dueDate!)), at: 0)
        }
        
        
        self.calendarView.reloadData()
      })
   print("DATA3: \(self.data)")
    
  }
  // ////////////////// //
  // MARK: - UI         //
  // ////////////////// //
  
  fileprivate func shouldDisplayUI() {
  
    // set up of mood button color behavior on tap
    for button in moodButtons {
      button.typeOfButton = .imageButton
    }
    
    let rightButton: UIBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addChallenge))
    self.navigationItem.rightBarButtonItem = rightButton
    setupCalendarView()
  }
  
  func setupCalendarView() {
    // register cell
    let nib = UINib(nibName: "CalendarCell", bundle: nil)
    let headerNib = UINib(nibName: "headerView", bundle: nil)
    calendarView.register(nib, forCellWithReuseIdentifier: "dateCell")
    calendarView.register(headerNib, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
    // UI appearance settings
    calendarView.minimumLineSpacing = 0
    calendarView.minimumInteritemSpacing = 0
    calendarView.backgroundColor = .clear
    // delegation attribtution
    calendarView.ibCalendarDelegate = self
    calendarView.ibCalendarDataSource = self
    calendarView.isScrollEnabled = false
    calendarView.scrollToDate(Date(),animateScroll: false)
    calendarView.selectDates([Date()])
    calendarView.scrollingMode = .stopAtEachCalendarFrame
    self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
      self.setupViewsOfCalendar(from: visibleDates)
    }
   
    
  }
  
  fileprivate func handleNotifications() {
    NotificationCenter.default.addObserver(self, selector:#selector(addChallenge), name: NSNotification.Name(rawValue: "calendarActive"), object: nil)
    print(currentUser)
  }
  // ////////////////// //
  // MARK: - ACTIONS    //
  // ////////////////// //
  
  /// handle the color display behavior when user tap a button
  ///
  /// - Parameter sender: CustomUIButtonForUIToolbar
  @IBAction func moodButtonTapped(_ sender: CustomUIButtonForUIToolbar) {
    evaluateMoodButtonState()
    firebaseService.saveMood(for: currentUser, state: sender.tag, date: Date().timeIntervalSince1970)
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
    if let challengeToPresent = selectedChallenge{
      let challengeVc = ProgressViewController()
     // challengeVc.challenge = challengeToPresent
      self.navigationController?.pushViewController(challengeVc, animated: true)
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
}
