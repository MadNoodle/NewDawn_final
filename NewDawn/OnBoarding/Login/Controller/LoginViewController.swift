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
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {

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
      // Verify connection with Firebase
     LoginService.Source.connect(with: .email, in: self, infos: (loginTextfield.text!,passwordTextfield.text!))
    
    case .failure(_, let message):
      // if not valid display error
      UserAlert.show(title: "Error", message: message.localized(), controller: self)
    }
  }
  
  @IBAction func resetPassword(_ sender: UIButton) {
    let resetVc = ResetViewController()
    self.present(resetVc, animated: true)
  }
  
  @IBAction func loginWithTwitter(_ sender: UIButton) {
    LoginService.Source.connect(with: .twitter, in: self, infos: nil)
     showLoader()
  }
 
  @IBAction func loginWithFB(_ sender: UIButton) {
    LoginService.Source.connect(with: .facebook, in: self, infos: nil)
    showLoader()
  }
  
  @IBAction func createAccount(_ sender: GradientButton) {
    let registerVc = RegisteringViewController()
    self.present(registerVc, animated: true)
  }
  
  fileprivate func showLoader() {
    let bgView = UIImageView()
    bgView.frame = self.view.frame
    bgView.image = UIImage(named: "bg")
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    indicator.frame = self.view.frame
    self.view.addSubview(bgView)
    self.view.addSubview(indicator)
    indicator.startAnimating()
  }
  
}
