///**
/**
NewDawn
Created by: Mathieu Janneau on 30/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit
import UserNotifications

class CreateChallengeViewController: UIViewController {


  var tableViewTitle: String?
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
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
      if error != nil {
        print("authorization Unsuccessful")
      } else {
         print("authorization successful")
      }
    }
    guard let challenge = tableViewTitle else { return}
      titleLabel.text = challenge

    
    }
  
  override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(self, selector:#selector(didUpdateDate), name: NSNotification.Name(rawValue: "ValueChanged"), object: nil)
    NotificationCenter.default.addObserver(self, selector:#selector(didUpdateLocation), name: NSNotification.Name(rawValue: "LocationChanged"), object: nil)

    
  }
  
  // /////////////////////// //
  // MARK: - DATE MANAGEMENT //
  // /////////////////////// //
  
  let launcher = DateLauncher()
  var challengeDate: Date?
  
  
  @IBAction func addDate(_ sender: UIButton) {
  launcher.showSettings()
  }
  
  @objc func didUpdateDate(notif:NSNotification){
    print ("received notification")
    // receive data from Picker
    challengeDate = notif.userInfo?["Date"] as? Date
    
    if let dateToRemind = challengeDate{
    // Create date formatter
    let dateFormatter: DateFormatter = DateFormatter()
     dateFormatter.timeZone = TimeZone.current
    // Set date format
      dateFormatter.dateFormat = DateFormat.dayHourMinute.rawValue
    
    // Apply date format
    dateLabel.text = dateFormatter.string(from: dateToRemind )}
  }
  
  // ////////////////////// //
  // MARK: - NOTIFICATIONS  //
  // ////////////////////// //
  
  var notificationId = ""

  @IBAction func userDidActivateNotification(_ sender: UISwitch) {
    
    if sender.isOn {
      if challengeDate != nil {
        
        // create notification
        notification() { (success) in
          if success { print("yahoo")}
        }
        print("notif")
      }
      else {
        // show an alert
        print("entre une date")
        
      }
      
    } else {
      // purge notification
      NotificationService.removeNotification(notificationId)
     // NotificationService.scheduleNotification(notificationId,to: challengeDate!, challenge: titleLabel.text!)
    }
  }
  
  func notification( completion:@escaping (_ success: Bool) ->()) {
    
    
    
    if let date = challengeDate {
      var calendar = Calendar.current
      calendar.timeZone = .autoupdatingCurrent
      let componentsFromDate = calendar.dateComponents([.hour, .minute, .day, .month,.year], from: date)
    // trigger
    let trigger = UNCalendarNotificationTrigger(dateMatching: componentsFromDate, repeats: false)
      
    //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
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
    if let location = notif.userInfo!["Location"] as? (Double,Double, String){
      locationLabel.text = location.2
      
    }
  }
  
  @IBAction func CreateChallenge(_ sender: GradientButton) {
    
  
  }
}
