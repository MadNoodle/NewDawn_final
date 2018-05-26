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

  var currentUser = ""
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var passwordTextfield: CustomTextField!
  @IBOutlet weak var loginTextfield: CustomTextField!
  @IBOutlet weak var signInButton: GradientButton!
  @IBOutlet weak var fbButton: UIButton!
  @IBOutlet weak var twitterButton: UIButton!
  @IBOutlet weak var createAccount: GradientButton!
  @IBOutlet weak var forgotPasswordButton: UIButton!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // load logged user
    if let user = UserDefaults.standard.object(forKey: UIConfig.currentUserKey) as? String {
      currentUser = user
    }
    shouldDisplayUIText()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // check if a user is already login
    if Auth.auth().currentUser != nil {
      // user logged
      LoginService.shared.validateUser(currentUser)
    } else {
      print("no user logged")
    }
  }
  
  // /////////////// //
  // MARK: - UI METHODS //
  // /////////////// //
  
  /// Populate all UI texts
  fileprivate func shouldDisplayUIText() {
    loginTextfield.placeholder = NSLocalizedString("emailPlaceholder", comment: "")
    passwordTextfield.placeholder = NSLocalizedString("passwordPlaceholder", comment: "")
    signInButton.setTitle(NSLocalizedString("signIn", comment: ""), for: .normal)
    forgotPasswordButton.setTitle(NSLocalizedString("forgotPassword", comment: ""), for: .normal)
    fbButton.setTitle(NSLocalizedString("fbLogin", comment: ""), for: .normal)
    twitterButton.setTitle(NSLocalizedString("twitterLogin", comment: ""), for: .normal)
    createAccount.setTitle(NSLocalizedString("createAccount", comment: ""), for: .normal)
  }
  // /////////////// //
  // MARK: - ACTIONS //
  // /////////////// //
  
  @IBAction func signIn(_ sender: GradientButton) {
    // check if fields are valid
    let response = Validator.shared.validate(values:
                                              (ValidationType.email, loginTextfield.text!),
                                             (ValidationType.password, passwordTextfield.text!))
    switch response {
    case .success:
      // Verify connection with Firebase
     LoginService.shared.connect(with: .email, in: self, infos: (loginTextfield.text!, passwordTextfield.text!))
    
    case .failure(_, let message):
      // if not valid display error
      UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: message.localized(), controller: self)
    }
  }
  
  @IBAction func resetPassword(_ sender: UIButton) {
    let resetVc = ResetViewController()
    self.present(resetVc, animated: true)
  }
  
  @IBAction func loginWithTwitter(_ sender: UIButton) {
    LoginService.shared.connect(with: .twitter, in: self, infos: nil)
     showLoader()
  }
 
  @IBAction func loginWithFB(_ sender: UIButton) {
    LoginService.shared.connect(with: .facebook, in: self, infos: nil)
    showLoader()
  }
  
  @IBAction func createAccount(_ sender: GradientButton) {
    let registerVc = RegisteringViewController()
    self.present(registerVc, animated: true)
  }
  
  /// Display a loader while fetching data and presenting main App controller
  fileprivate func showLoader() {
    // create a background
    let bgView = UIImageView()
    bgView.frame = self.view.frame
    // Assign background image
    bgView.image = UIImage(named: UIConfig.loaderBg)
    // Create spinner
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    indicator.frame = self.view.frame
    self.view.addSubview(bgView)
    self.view.addSubview(indicator)
    // show & animate
    indicator.startAnimating()
  }
  
}
