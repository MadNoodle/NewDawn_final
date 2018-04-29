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
  var databaseRef : DatabaseReference = {
    return Database.database().reference()
  }()
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
      print("sucess")
      Auth.auth().createUser(withEmail: emailTextField.text!, password: repeatPasswordTexfield.text!) { (user, error) in
        
        if error != nil {
         
          UserAlert.show(title: "Sorry", message: error!.localizedDescription, controller: self)
        } else {
       if let u = user {
        UserDefaults.standard.set(u.email!, forKey: "currentUser")
        let userRef = self.databaseRef.child("users").childByAutoId()
        let userToStore = TempUser(username: self.emailTextField.text!, password: self.passwordTextField.text!, lastName: self.lastNameTextfield.text!, firstName: self.firstNameTextfield.text!)
        userRef.setValue(userToStore.toAnyObject())
        let newHomeVc = MainTabBarController()
        newHomeVc.selectedIndex = 1
        
        self.present(newHomeVc, animated: true)
        }}
        
      }
  
    case .failure(_, let message):
      // if not valid display error
      print(message.localized())
      UserAlert.show(title: "Error", message: message.localized(), controller: self)
    }

    
  }
}
