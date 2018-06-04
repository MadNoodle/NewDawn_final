///**
/**
 NewDawn
 Created by: Mathieu Janneau on 02/05/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit
import UserNotifications
import Firebase
import FirebaseDatabase

/// This controller allows the user to create and edit predefined challenges
class EditChallengeViewController: UIViewController {
  
  /// Currently loggged user
  var currentUser = ""
  
  /// Dummy location
  var destination = ChallengeDestination(locationName: "", lat: 0, long: 0)
  
  /// title
  var tableViewTitle: String?
  
  /// Notification state
  var isNotified: Int = 0
  
  /// Current Objective
  var objective: String?
  
  /// Container for challenge due date
  var challengeDate: Date?
  
  /// Currenttly selected Challenge
  var challenge: Challenge?
  
  /// Challenge ref in Database
  var challengeKey: String?
  
  /// Delegate that sends info for challenge
  weak var delegate: EditableChallenge?
  
  /// Edit or create
  var source: String?
  
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var notificationSwitch: UISwitch!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var anxietySlider: NStopSlider!
  @IBOutlet weak var benefitSlider: NStopSlider!
  @IBOutlet weak var validateButton: GradientButton!
  @IBOutlet weak var benefitLabel: UILabel!
  @IBOutlet weak var anxietyLabel: UILabel!
  @IBOutlet weak var notificationLabel: UILabel!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(didUpdateDate),
                                           name: NSNotification.Name(rawValue: "ValueChanged"),
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(didUpdateLocation),
                                           name: NSNotification.Name(rawValue: "LocationChanged"),
                                           object: nil)
    if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
      currentUser = user
    }
    dateLabel.text = NSLocalizedString("Add a date", comment: "")
    locationLabel.text = NSLocalizedString("Add an Objective Location", comment: "")
    notificationLabel.text = NSLocalizedString("Activate notifications", comment: "")
    anxietyLabel.text = NSLocalizedString("What the situation anxiety level?", comment: "")
    benefitLabel.text = NSLocalizedString("Rate the Benefit you expect", comment: "")
    validateButton.setTitle(NSLocalizedString("Create Challenge", comment: ""), for: .normal)
    if delegate != nil {
     // guard let challengeKey = delegate?.challengeKey else { return}
      guard let challenge = delegate?.challengeToSend else { return}
      titleLabel.text = challenge.name
      dateLabel.text = Date(timeIntervalSince1970: challenge.dueDate).convertToString(format: .annual)
      challengeDate = Date(timeIntervalSince1970: challenge.dueDate)
      objective = challenge.objective
      if let location = challenge.destination {
        locationLabel.text = location}
      if let state = challenge.isNotified {
        if state == 1 {
          notificationSwitch.isOn = true
        } else {notificationSwitch.isOn = false }
      }
      if let anxiety = challenge.anxietyLevel {
        anxietySlider.value = Float(anxiety)
      }
      if let benefit = challenge.benefitLevel {
        benefitSlider.value = Float(benefit)
      }
    } else {
      guard let challenge = tableViewTitle else { return}
      titleLabel.text = challenge
    }
    shouldAskNotificationPermission()
    self.edgesForExtendedLayout = []
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.view.setNeedsDisplay()
    self.dateLabel.setNeedsDisplay()
    
  }
  
  // /////////////////////// //
  // MARK: - DATE MANAGEMENT //
  // /////////////////////// //
  
  let launcher = DateLauncher()
  
  @IBAction func addDate(_ sender: UIButton) {
    launcher.showSettings()
  }
  
  @objc func didUpdateDate(notif: NSNotification) {
    print ("received notification")
    // receive data from Picker
    
    challengeDate = notif.userInfo?["Date"] as? Date
    if let dateToRemind = challengeDate {
      // Create date formatter
      let dateFormatter: DateFormatter = DateFormatter()
      dateFormatter.timeZone = TimeZone.current
      // Set date format
      dateFormatter.dateFormat = DateFormat.dayHourMinute.rawValue
      
      // Apply date format
      dateLabel.text = dateFormatter.string(from: dateToRemind )
    }
  }
  
  // ////////////////////// //
  // MARK: - NOTIFICATIONS  //
  // ////////////////////// //
  
  var notificationId = ""
  
  @IBAction func userDidActivateNotification(_ sender: UISwitch) {
    
    if sender.isOn {
      if challengeDate != nil {
        isNotified = 1
        // create notification
        notification() { (success) in
          if success { print("success")}
        }
      } else {
        isNotified = 0
      }
      
    } else {
      isNotified = 0
      // purge notification
      NotificationService.removeNotification(notificationId)
    }
  }
  
  func notification( completion:@escaping (_ success: Bool) -> Void) {
    if let date = challengeDate {
      var calendar = Calendar.current
      calendar.timeZone = .autoupdatingCurrent
      let componentsFromDate = calendar.dateComponents([.hour, .minute, .day, .month, .year], from: date)
      // trigger
      let trigger = UNCalendarNotificationTrigger(dateMatching: componentsFromDate, repeats: false)
      
      let content = UNMutableNotificationContent()
      content.title = NSLocalizedString("it's Challenge Time", comment: "")
      if let message = titleLabel.text {
        content.body = NSLocalizedString("here is your challenge:", comment: "") + message
        
      }
      content.sound = UNNotificationSound.default()
      let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
      UNUserNotificationCenter.current().add(request) { (error) in
        if error != nil {
          completion(false)
        } else {
          completion(true)
        }
      }
    }
  }
  
  // //////////////////////////// //
  // MARK: - LOCATION MANAGEMENT  //
  // //////////////////////////// //
  
  @IBAction func addLocation(_ sender: UIButton) {
    let locVc = DestinationViewController(nibName: nil, bundle: nil)
    self.navigationController?.pushViewController(locVc, animated: true)
  }
  
  @objc func didUpdateLocation(notif: NSNotification) {
    if let location = notif.userInfo!["Location"] as? (Double, Double, String) {
      destination.locationName = location.2
      destination.lat = location.0
      destination.long = location.1
      locationLabel.text = location.2
    }
  }
 
  @IBAction func updateChallenge(_ sender: GradientButton) {
    
    if let dueDate = challengeDate?.timeIntervalSince1970 {
      
      if source != nil {
        // create challenge
        DatabaseService.shared.createChallenge(dueDate: dueDate, user: currentUser, name: titleLabel.text!, objective: objective!, anxietyLevel: Int(anxietySlider.value), benefitLevel: Int(benefitSlider.value), isDone: 0, isNotified: isNotified, isSuccess: 0, destination: destination.locationName, destinationLat: destination.lat, destinationLong: destination.long) {(error) in
          if error != nil {
            UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
          }
          
          // send back to challenge list
          let mainVc = MainTabBarController()
          mainVc.selectedIndex = 1
          self.present(mainVc, animated: true)
        }
      } else {
      
        if delegate != nil {
          // grab uid for challenge
          let key = delegate?.challengeKey
          // update challenge
          DatabaseService.shared.updateChallenge(dueDate: dueDate, key: key, user: currentUser, name: titleLabel.text!, objective: objective!, anxietyLevel: Int(anxietySlider.value), benefitLevel: Int(benefitSlider.value), isDone: 0, isNotified: isNotified, isSuccess: 0, destination: destination.locationName, destinationLat: destination.lat, destinationLong: destination.long) {(error) in
            if error != nil {
              UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
            }
            
            // send back to challenge list
            let mainVc = MainTabBarController()
            mainVc.selectedIndex = 1
            self.present(mainVc, animated: true)
            UserAlert.show(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Your challenge has been updated", comment: ""), controller: mainVc)
            
          }
          
        }
        
      }
    } else {
      // show an alert if no date is entered
      UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Please enter a valid date", comment: ""), controller: self)}
    
  }
 
  /// Ask permission to use notifications to userx
  fileprivate func shouldAskNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (_, error) in
      if error != nil {
         UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Please allow notification use for NewDawn", comment: ""), controller: self)
      } else {
        print("authorization successful")
      }
    }
  }
  
}
