///**
/**
NewDawn
Created by: Mathieu Janneau on 30/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit
import UserNotifications
import Firebase
import FirebaseDatabase

class CreateChallengeViewController: UIViewController {

  var currentUser = ""
  var destination = ChallengeDestination(locationName: "", lat: 0, long: 0)
  var tableViewTitle: String?
  var isNotified: Bool = false
  var objective: String?
  var challengeDate: Date?
  var delegate: EditableChallenge?
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var notificationSwitch: UISwitch!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var anxietySlider: NStopSlider!
  @IBOutlet weak var benefitSlider: NStopSlider!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector:#selector(didUpdateDate), name: NSNotification.Name(rawValue: "ValueChanged"), object: nil)
    NotificationCenter.default.addObserver(self, selector:#selector(didUpdateLocation), name: NSNotification.Name(rawValue: "LocationChanged"), object: nil)
    if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
      currentUser = user
    }
   
    if delegate != nil {

      titleLabel.text = delegate?.storedTitle
      dateLabel.text = delegate?.storedDate?.convertToString(format: .dayHourMinute)
      //// REFACTOR MODEL
     challengeDate = delegate?.storedDate

      /////
      objective = delegate?.storedObjective
      locationLabel.text = delegate?.storedLocation
      if let state = delegate?.storedNotificationState {
        notificationSwitch.isOn = state
      }
      if let anxiety = delegate?.storedAnxiety {
      anxietySlider.value = Float(anxiety)
      }
      if let benefit = delegate?.storedBenefit {
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
  
  @objc func didUpdateDate(notif:NSNotification){
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
        isNotified = true
        // create notification
        notification() { (success) in
          if success { print("success")}
        }
        print("notif")
      }
      else {
        // Show alert
        print("entre une date")
        
      }
      
    } else {
      isNotified = false
      // purge notification
      NotificationService.removeNotification(notificationId)
    }
  }
  
  func notification( completion:@escaping (_ success: Bool) ->()) {
    if let date = challengeDate {
      var calendar = Calendar.current
      calendar.timeZone = .autoupdatingCurrent
      let componentsFromDate = calendar.dateComponents([.hour, .minute, .day, .month,.year], from: date)
    // trigger
    let trigger = UNCalendarNotificationTrigger(dateMatching: componentsFromDate, repeats: false)

    let content = UNMutableNotificationContent()
      content.title = "it's Challenge Time"
      if let message = titleLabel.text
     { content.body = "here is your challenge: \(message)"}
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
  
  @objc func didUpdateLocation(notif:NSNotification) {
    if let location = notif.userInfo!["Location"] as? (Double, Double, String) {
    
      destination.locationName = location.2
      destination.lat = location.0
      destination.long = location.1
      locationLabel.text = location.2
      
    }
  }
  
  var databaseRef : DatabaseReference = {
    return Database.database().reference()
  }()
  @IBAction func createChallenge(_ sender: GradientButton) {
    print("boom")
    if let dueDate = challengeDate?.timeIntervalSince1970{
    
    CoreDataService.saveChallenge(user: currentUser, name: titleLabel.text!, dueDate: dueDate, isNotified: isNotified , anxietyLevel: Int(anxietySlider.value), benefitLevel: Int(benefitSlider.value), objective: objective!, location: destination)
      
      let challengeRef = databaseRef.child("challenges").childByAutoId()
      let challengeToStore = TempChallenge(user: currentUser, name: titleLabel.text!, objective: objective!, dueDate: dueDate, anxietyLevel: Int(anxietySlider.value), benefitLevel: Int(benefitSlider.value), isNotified: isNotified, destination: destination.locationName, destinationLat: destination.lat, destinationLong: destination.long)
      challengeRef.setValue(challengeToStore.toAnyObject())
      
    let mainVc = MainTabBarController()
    mainVc.selectedIndex = 1
    present(mainVc,animated: true)
    } else {
      
      UserAlert.show(title: "Error", message: "Please enter a date for challenge", controller: self)
    }
    

  }



fileprivate func shouldAskNotificationPermission() {
  UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
    if error != nil {
      print("authorization Unsuccessful")
    } else {
      print("authorization successful")
    }
  }
}
}
