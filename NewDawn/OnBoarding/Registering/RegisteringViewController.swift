///**
/**
 NewDawn
 Created by: Mathieu Janneau on 13/04/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit

class RegisteringViewController: UIViewController {
  
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
  @IBAction func changeProfilPicture(_ sender: UIButton) {
  }
  
  @IBAction func createAccount(_ sender: UIButton) {
    
    // check if fields are valid
    let response = Validator.shared.validate(values:
      (ValidationType.email, emailTextField.text!),
      (ValidationType.password,passwordTextField.text!),
      (ValidationType.password,repeatPasswordTexfield.text!),
      (ValidationType.alphabeticString,lastNameTextfield.text!),
      (ValidationType.alphabeticString,firstNameTextfield.text!))
    switch response {
    case .success:
      print("sucess")
      // check if user is registered in bdd
      break
    case .failure(_, let message):
      // if not valid display error
      print(message.localized())
      UserAlert.show(title: "Error", message: message.localized(), vc: self)
    }
   

    let newHomeVc = MainTabBarController()
    newHomeVc.selectedIndex = 1
   
    self.present(newHomeVc,animated:true)
  }
}