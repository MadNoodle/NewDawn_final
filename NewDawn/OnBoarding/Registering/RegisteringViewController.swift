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

/// This Controller alows the user to create an account by asking
/// lastName / firstName / email / password
class RegisteringViewController: UIViewController {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  /// Instantiate Authentication Service
  let firebaseService = FirebaseService()
  
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
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
    shouldDisplayPlaceholders()
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
        UserAlert.show(title: LocalisationString.ErrorTitles.error.rawValue, message: LocalisationString.RegisteringAlert.differentPassword.rawValue , controller: self)
      } else {

        // set username
        let fullName = "\(lastNameTextfield.text!) \(firstNameTextfield.text!)"
        // signup & add to bdd
        
        firebaseService.signUp(email: emailTextField.text!, username: fullName, password: passwordTextField.text!, in: self)
        // Format creation date to string
        let formater = DateFormatter()
        formater.dateFormat = DateFormat.annual.rawValue
        let creationDate = formater.string(from: Date())
        // Store new user in BDD
        DatabaseService.shared.createUser(date: creationDate, username: emailTextField.text!, password: passwordTextField.text!) { (error) in
          
          if error != nil {
            print("error")
          }}
        // set current user
        UserDefaults.standard.set(emailTextField.text!, forKey: UIConfig.currentUserKey)
        // present controller
        let newHomeVc = MainTabBarController()
        newHomeVc.selectedIndex = 1
        self.present(newHomeVc, animated: true)}
      
    case .failure(_, let message):
      // if not valid display error
      UserAlert.show(title: LocalisationString.ErrorTitles.error.rawValue, message: message.localized(), controller: self)
    }
  }
  
  // ////////////////// //
  // MARK: - UI DISPLAY //
  // ////////////////// //
  
  func shouldDisplayPlaceholders() {
    lastNameTextfield.placeholder = LocalisationString.RegisterString.lastNamePlaceholder.rawValue
    firstNameTextfield.placeholder = LocalisationString.RegisterString.firstNamePlaceholder.rawValue
    emailTextField.placeholder = LocalisationString.RegisterString.emailPlaceholder.rawValue
    passwordTextField.placeholder = LocalisationString.RegisterString.passwordPlaceholder.rawValue
    repeatPasswordTexfield.placeholder = LocalisationString.RegisterString.repeatPasswordPlaceholder.rawValue
  }
}
