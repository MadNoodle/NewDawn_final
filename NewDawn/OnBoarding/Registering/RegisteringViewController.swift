///**
/**
 NewDawn
 Created by: Mathieu Janneau on 13/04/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisteringViewController: UIViewController {
  let firebaseService = FirebaseService()
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var profilPicture: RoundedImage!
  @IBOutlet weak var lastNameTextfield: CustomTextField!
  @IBOutlet weak var firstNameTextfield: CustomTextField!
  @IBOutlet weak var emailTextField: CustomTextField!
  @IBOutlet weak var repeatPasswordTexfield: CustomTextField!
  @IBOutlet weak var passwordTextField: CustomTextField!
  
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
  
  @IBAction func back(_ sender: UIButton) {
    dismiss(animated: true)
  }
  @IBAction func createAccount(_ sender: UIButton) {
    
    // check if fields are valid
    let response = Validator.shared.validate(values:
      (ValidationType.email, emailTextField.text!),
                                             (ValidationType.password, passwordTextField.text!),
                                             (ValidationType.password, repeatPasswordTexfield.text!),
                                             (ValidationType.alphabeticString, lastNameTextfield.text!),
                                             (ValidationType.alphabeticString, firstNameTextfield.text!))
    switch response {
    case .success:
      if passwordTextField.text! != repeatPasswordTexfield.text! {
        // show alert if conditions are not fulfilled
        UserAlert.show(title: "Error", message: "the two passords are differents, please retry", controller: self)
      } else{
        print("success")
        // set username
        let fullName = "\(lastNameTextfield.text!) \(firstNameTextfield.text!)"
        // signup & add to bdd
        
        firebaseService.signUp(email: emailTextField.text!, username: fullName, password: passwordTextField.text!, in: self)
        // set current user
        UserDefaults.standard.set(emailTextField.text!, forKey: "currentUser")
        // present controller
        let newHomeVc = MainTabBarController()
        newHomeVc.selectedIndex = 1
        self.present(newHomeVc, animated: true)}
      
      
    case .failure(_, let message):
      // if not valid display error
      UserAlert.show(title: "Error", message: message.localized(), controller: self)
    }
    
    
  }
}
