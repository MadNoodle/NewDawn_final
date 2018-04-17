///**
/**
NewDawn
Created by: Mathieu Janneau on 12/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit

class ResetViewController: UIViewController {
  
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var inputEmail: CustomTextField!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
  // /////////////// //
  // MARK: - ACTIONS //
  // /////////////// //
  
  @IBAction func reset(_ sender: UIButton) {
    // check if fields are valid
    let response = Validator.shared.validate(values:
      (ValidationType.email, inputEmail.text!))
    switch response {
    case .success:
      print("sucess")
      // check if user is registered in bdd
    case .failure(_, let message):
      // if not valid display error
      print(message.localized())
      UserAlert.show(title: "Error", message: message.localized(), controller: self)
    }
    // send mail with password cf firebase
    let loginVc = LoginViewController()
    self.present(loginVc, animated: true)
  }
}
