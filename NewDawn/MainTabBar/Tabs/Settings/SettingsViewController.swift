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
    button.setTitle("back", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.contentHorizontalAlignment = .left
    return button
  }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
        currentUser = user
      }
    
      self.view.addSubview(navBar)
      navBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
      navBar.addSubview(backButton)
      backButton.frame = CGRect(x: 8, y: 28, width: 100, height: 34)
      backButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
     
    
    }

  @IBAction func resetData(_ sender: UIButton) {
    CoreDataService.resetCoreDataStack(for: currentUser)
  }
  @IBAction func logOut(_ sender: UIButton) {
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
      UserDefaults.standard.set("", forKey: "currentUser")
      let loginVc = LoginViewController()
      self.present(loginVc,animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
    
  }
  @objc func handleDismiss() {
    self.dismiss(animated: true, completion: nil)
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBAction func back(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}
