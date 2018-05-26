///**
/**
NewDawn
Created by: Mathieu Janneau on 26/05/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit
import UserNotifications
import Firebase
import FirebaseDatabase

/// This controller allows use to create a custom challenge
class CreateCustomChallengeViewController: UIViewController {
  
  /// stores current user
  var currentUser = ""
  
  /// Insttantiate an empty destination
  var destination = ChallengeDestination(locationName: "", lat: 0, long: 0)
  
  /// title
  var tableViewTitle: String?
  
  /// stores notification state
  var isNotified: Int = 0
  
  /// Current objective
  var objective: String?
  
  /// stores challenge due date
  var challengeDate: Date?
  
  /// stores current challenge
  var challenge: Challenge?
  
  /// Stores  current Challenge Database key
  var challengeKey: String?

  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  

  @IBOutlet weak var titleField: UITextField!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var notificationSwitch: UISwitch!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var anxietySlider: NStopSlider!
  @IBOutlet weak var benefitSlider: NStopSlider!
  @IBOutlet weak var validateButton: GradientButton!
  @IBOutlet weak var anxietyLabel: UILabel!
  @IBOutlet weak var benefitLabel: UILabel!
  @IBOutlet weak var notificationLabel: UILabel!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleField.delegate = self
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
    titleField.placeholder = NSLocalizedString("Give a name to your challenge", comment: "")
   dateLabel.text = NSLocalizedString("Add a date", comment: "")
    locationLabel.text = NSLocalizedString("Add an Objective Location", comment: "")
    notificationLabel.text = NSLocalizedString("Activate notifications", comment: "")
    anxietyLabel.text = NSLocalizedString("What the situation anxiety level?", comment: "")
    benefitLabel.text = NSLocalizedString("Rate the Benefit you expect", comment: "")
    validateButton.setTitle(NSLocalizedString("Create Challenge", comment: ""), for: .normal)
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
  
  /// Container for notification Id allows to create multiple ids
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
      if let message = titleField.text {
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
    
    // check if user has entered a date
    if let dueDate = challengeDate?.timeIntervalSince1970 {
      
        // create challenge
        DatabaseService.shared.createChallenge(dueDate: dueDate, user: currentUser, name: titleField.text!, objective: objective!, anxietyLevel: Int(anxietySlider.value), benefitLevel: Int(benefitSlider.value), isDone: 0, isNotified: isNotified, isSuccess: 0, destination: destination.locationName, destinationLat: destination.lat, destinationLong: destination.long) {(error) in
          if error != nil {
            UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
          }
          
          // send back to challenge list
          let mainVc = MainTabBarController()
          mainVc.selectedIndex = 1
          self.present(mainVc, animated: true)
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


// MARK: - UITEXTFIELD DELEGATE
extension CreateCustomChallengeViewController: UITextFieldDelegate {
  
  ///  When user touches outside of the text field. it validates his text
  /// and send translation request. the keyboard disappear.
  ///
  /// - Parameters:
  ///   - touches: Touch
  ///   - event: event that trigger the action
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  /// When user presses enter on keyboard. it validates his text
  /// and send translation request. the keyboard disappear.
  ///
  /// - Parameter textField:  input textField
  /// - Returns: Boolean
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return (true)
  }
}

