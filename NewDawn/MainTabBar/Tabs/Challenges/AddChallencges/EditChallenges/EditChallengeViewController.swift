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

class EditChallengeViewController: UIViewController {

  var currentUser = ""
  var destination = ChallengeDestination(locationName: "", lat: 0, long: 0)
  var tableViewTitle: String?
  var isNotified: Bool = false
  var objective: String?
  var challengeDate: Date?
  var challenge: TempChallenge?
  var challengeKey: String?
  var delegate: EditableChallenge?
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
      guard let challengeKey = delegate?.challengeKey else {return}
      print("LA CLE DU BONHEUR: \(challengeKey)")
      guard let challenge = delegate?.challengeToSend else { return}
      titleLabel.text = challenge.name
      dateLabel.text = Date(timeIntervalSince1970: challenge.dueDate).convertToString(format: .annual)
      challengeDate = Date(timeIntervalSince1970: challenge.dueDate)
      objective = challenge.objective
      if let location = challenge.destination{
      locationLabel.text = location}
      if let state = challenge.isNotified {
        if state == 1 {
          notificationSwitch.isOn = true }
        else {notificationSwitch.isOn = false }
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
  
  @IBAction func updateChallenge(_ sender: GradientButton) {
     databaseRef = Database.database().reference()
   

    if let dueDate = challengeDate?.timeIntervalSince1970{
      
      if source != nil {
        print(dueDate)

        let challengeToStore = ["user":currentUser,"name": titleLabel.text!, "objective": objective!, "dueDate": dueDate, "anxietyLevel": Int(anxietySlider.value), "benefitLevel": Int(benefitSlider.value), "isNotified": isNotified, "isDone": false, "isSuccess": false, "destination": destination.locationName, "destinationLat": destination.lat, "destinationLong": destination.long, "comment": ""] as [String : Any]
        DatabaseService.shared.challengeRef.childByAutoId().setValue(challengeToStore)
        print("create")
        
      } else {
        print("update")
        if delegate != nil {
        let key = delegate?.challengeKey
        print("------------------------\(key)")
       
        
        let updatedChallenge = ["user":currentUser,"name": titleLabel.text!, "objective": objective!, "dueDate": dueDate, "anxietyLevel": Int(anxietySlider.value), "benefitLevel": Int(benefitSlider.value), "isNotified": isNotified, "isDone": false, "isSuccess": false, "destination": destination.locationName, "destinationLat": destination.lat, "destinationLong": destination.long, "comment": ""] as [String : Any]
        
        DatabaseService.shared.challengeRef.child(key!).updateChildValues(updatedChallenge)
          
        }
      // update DB
     

      let mainVc = MainTabBarController()
      mainVc.selectedIndex = 1
      self.present(mainVc,animated: true)
    }
    } else {
      UserAlert.show(title: "Error", message: "Please enter a valid date", controller: self)}
      
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
