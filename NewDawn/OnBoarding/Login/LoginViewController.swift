///**
/**
NewDawn
Created by: Mathieu Janneau on 12/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
  
  let mainVc = MainTabBarController()
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  @IBOutlet weak var passwordTextfield: CustomTextField!
  @IBOutlet weak var loginTextfield: CustomTextField!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  // /////////////// //
  // MARK: - ACTIONS //
  // /////////////// //
  @IBAction func signIn(_ sender: GradientButton) {
    // check if fields are empty

      // check if fields are valid
      let response = Validator.shared.validate(values:
                                              (ValidationType.email, loginTextfield.text!),
                                               (ValidationType.password, passwordTextfield.text!))
      switch response {
      case .success:
        print("sucess")
         // check if user is registered in bdd
        Auth.auth().signIn(withEmail: loginTextfield.text!, password: passwordTextfield.text!) { (user, error) in
          // check if error
          if error != nil {
            // if so display alert
            UserAlert.show(title: "Sorry", message:error!.localizedDescription, controller: self)
          } else{
            if let u = user {
              // set current user
             UserDefaults.standard.set(u.email!, forKey: "currentUser")
              print(u)
              self.present(self.mainVc, animated: true)
            }}
            
          
        }
      case .failure(_, let message):
        // if not valid display error
        print(message.localized())
        UserAlert.show(title: "Error", message: message.localized(), controller: self)
      } 
    

  }
  
  @IBAction func resetPassword(_ sender: UIButton) {
    let resetVc = ResetViewController()
    self.present(resetVc, animated: true)
  }
  
  @IBAction func loginWithTwitter(_ sender: UIButton) {
     self.present(mainVc, animated: true)
  }
  @IBAction func loginWithFB(_ sender: UIButton) {
     self.present(mainVc, animated: true)
  }
  @IBAction func createAccount(_ sender: GradientButton) {
    let registerVc = RegisteringViewController()
    self.present(registerVc, animated: true)
  }
}
