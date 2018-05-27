///**
/**
NewDawn
Created by: Mathieu Janneau on 11/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {
var currentUser = ""
  var navBar: UIView = {
    let bar = UIView()
     bar.backgroundColor = UIConfig.lightGreen
    return bar
  }()
  
  let backButton: UIButton = {
    let button = UIButton()
    button.setTitle(NSLocalizedString("back", comment: ""), for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.contentHorizontalAlignment = .left
    return button
  }()
  
  @IBOutlet weak var logOutButton: UIButton!
  @IBOutlet weak var resetButton: UIButton!
  @IBOutlet weak var changePasswordButton: UIButton!

  override func viewDidLoad() {
        super.viewDidLoad()
      
      if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
        currentUser = user
      }
    logOutButton.setTitle(NSLocalizedString("Log out", comment: ""), for: .normal)
    resetButton.setTitle(NSLocalizedString("ResetData", comment: ""), for: .normal)
    changePasswordButton.setTitle(NSLocalizedString("changePassword", comment: ""), for: .normal)
      self.view.addSubview(navBar)
      navBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
      navBar.addSubview(backButton)
      backButton.frame = CGRect(x: 8, y: 28, width: 100, height: 34)
      backButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
   
    }

  /// This methofs prompts an alert where user can decide
  /// whether he wants to delete all his data or not.
  /// there is no recovery for this action
  @IBAction func resetData(_ sender: UIButton) {
    // instantiate alertController
    let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""),
                                  message: NSLocalizedString("You are about to delete all your data", comment: ""),
                                  preferredStyle: .actionSheet)
    // delete action
    let firstAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .default) { _ -> Void in
      // purge challenges and moods for user
      DatabaseService.shared.purgeChallenges(for: self.currentUser)
      DatabaseService.shared.purgeMoods(for: self.currentUser, completionHandler: { status in
        print(status)
      })
    }
    // cancel action
    let secondAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { (_) -> Void in
      NSLog("You pressed button two")
    }
    
    alert.addAction(firstAction)
    alert.addAction(secondAction)
    present(alert, animated: true, completion: nil)
  }
  
  /// Action to logout the user and send him back the login screen
  @IBAction func logOut(_ sender: UIButton) {
    let firebaseAuth = Auth.auth()
    do {
      // SignOut from firebase
      try firebaseAuth.signOut()
      // reet Current user
      UserDefaults.standard.set("", forKey: UIConfig.currentUserKey)
      // send the user to login screen
      let loginVc = LoginViewController()
      self.present(loginVc, animated: true)
      
    } catch let signOutError as NSError {
      UserAlert.show(title: NSLocalizedString("Error signing out", comment: ""), message: signOutError.localizedDescription, controller: self)
    }
  }
  
  /// This function dismisses the settings screen
  @objc func handleDismiss() {
    self.dismiss(animated: true, completion: nil)
  }
  
  /// action triggered when the user wants to go back to the app
  @IBAction func back(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}
