///**
/**
NewDawn
Created by: Mathieu Janneau on 30/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit



class CreateChallengeViewController: UIViewController {

  var delegate: ChallengeControllerDelegate?

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
   if let challengeTitle = delegate?.sendChallengeTitle() {
    print("step2: \(challengeTitle)")
      titleLabel.text = challengeTitle}
  
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
    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
    
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
        NotificationService.scheduleNotification(notificationId,to: challengeDate!, challenge: titleLabel.text!)
      }
      else {print("entre une date")}
      
    } else {
     NotificationService.removeNotification(notificationId)
      
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
