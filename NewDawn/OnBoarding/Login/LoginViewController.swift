///**
/**
NewDawn
Created by: Mathieu Janneau on 12/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit

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
 
      case .failure(_, let message):
        // if not valid display error
        print(message.localized())
        UserAlert.show(title: "Error", message: message.localized(), controller: self)
      } 
      self.present(mainVc, animated: true)

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
