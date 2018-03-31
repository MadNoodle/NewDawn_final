///**
/**
NewDawn
Created by: Mathieu Janneau on 30/03/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit

class CreateChallengeViewController: UIViewController {

  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var notificationSwitch: UISwitch!
  @IBOutlet weak var anxietySlider: NStopSlider!
  @IBOutlet weak var benefitSlider: NStopSlider!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(self, selector:#selector(didUpdateDate), name: NSNotification.Name(rawValue: "ValueChanged"), object: nil)
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
    let date = notif.userInfo?["Date"]
    
    // Create date formatter
    let dateFormatter: DateFormatter = DateFormatter()
    
    // Set date format
    dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
    
    // Apply date format
    dateLabel.text = dateFormatter.string(from: date as! Date)
  }
  
  
  @IBAction func addLocation(_ sender: UIButton) {
    let locVc = DestinationViewController(nibName: nil, bundle: nil)
    self.navigationController?.pushViewController(locVc, animated: true)
  }
  
  @IBAction func CreateChallenge(_ sender: GradientButton) {
    
  
  }
}
