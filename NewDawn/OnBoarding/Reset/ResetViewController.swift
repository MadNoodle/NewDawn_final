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
  @IBAction func back(_ sender: UIButton) {
    dismiss(animated: true)
  }
  
  @IBAction func reset(_ sender: UIButton) {
    // check if fields are valid
    let response = Validator.shared.validate(values:
      (ValidationType.email, inputEmail.text!))
    switch response {
    case .success:
      LoginService.shared.resetPassword(for: inputEmail.text!, in: self)
    case .failure(_, let message):
      // if not valid display error
      UserAlert.show(title: LocalisationString.ErrorTitles.error.rawValue, message: message.localized(), controller: self)
    }
    // send mail with password firebase & present lofgin Vc
    let loginVc = LoginViewController()
    self.present(loginVc, animated: true)
  }
}
