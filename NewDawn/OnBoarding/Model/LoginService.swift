///**
/**
NewDawn
Created by: Mathieu Janneau on 28/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import TwitterKit
import TwitterCore

/// This service handle all the login process according to the different ways : email, Facebook, Twitter
class LoginService {
  
  /// Public Access Point to the singleton pattern
  static let shared = LoginService()
  private init() {}
  
  /// Instantiate FirebaseService methods for login
  let firebaseService = FirebaseService()
  
  /// Main View Controller displayed if login succeed
  let mainVc = MainTabBarController()
  
  /// Different kind of login offered to the user
  ///
  /// - email: user wants to log with his email
  /// - facebook: user wants to log with his FB account
  /// - twitter: user wants to log with his Twitter account
  enum Source {
    case email
    case facebook
    case twitter
  }
  
  /// This method handle the connection process with the type and the user infos
  ///
  /// - Parameters:
  ///   - provider: Source Connection type
  ///   - controller: Controller displaying the login screen
  ///   - infos: User infos
  func connect( with provider: Source, in controller: UIViewController, infos: (String, String)?) {
    switch provider {
    case .email:
      // User infos
      guard let connectors = infos else {return}
      LoginService.shared.handleMailLogin(login: connectors.0, password: connectors.1, in: controller)
    case .facebook:
      LoginService.shared.handleFBLogin(in: controller)
    case .twitter:
      LoginService.shared.handleTwitterLogin(in: controller)
    }
  }
  
  
  
  /// This methods calls the Twitter SDK and Firebase to hanfdle user login
  ///
  /// - Parameter controller: Controller which displays the login screen
  func handleTwitterLogin(in controller: UIViewController) {
    // Calls Twitter SDK login function
    TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
      if session != nil {
        // check if app receive the user token and allows connection
        guard let authToken = session?.authToken, let authTokenSecret = session?.authTokenSecret else { return}
        // stores it in credential
        let credential = TwitterAuthProvider.credential(withToken: authToken, secret: authTokenSecret)
        // Pass it to Firebase Authentication
        Auth.auth().signIn(with: credential) { (user, error) in
          if let error = error {
            // Shows an alert if error
            UserAlert.show(title: LocalisationString.sorry, message: error.localizedDescription, controller: controller)
            return
          }
          
          if let usr = user {
            // check if user exists in database
            self.firebaseService.database.queryOrdered(byChild: "email").queryEqual(toValue: "\(usr.uid)")
              .observe(.value) { (snapshot) in
                
                if snapshot.value is NSNull {
                  // if user does not exists in database create a user entry
                  self.firebaseService.saveInfo(user: usr, username: usr.uid, password: usr.uid)
                  self.validateUser(usr.uid, goto: controller)
                } else {
                  self.validateUser(usr.uid, goto: controller)
                }
            }
           
          }
        }
        } else {
        UserAlert.show(title: LocalisationString.sorry, message: (error?.localizedDescription)!, controller: controller)
      }
    })
  }
  
  func handleFBLogin(in controller: UIViewController) {
    
    let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
    fbLoginManager.logIn(withReadPermissions: ["email"], from: controller) { (result, error) -> Void in
      if error == nil {
        let fbloginresult: FBSDKLoginManagerLoginResult = result!
        // if user cancel the login
        if (result?.isCancelled)! {
          return
        }
        if fbloginresult.grantedPermissions.contains("email") {
          let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
          Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
              UserAlert.show(title: "Sorry", message: error.localizedDescription, controller: controller)
              return
            }
            if let usr = user {
              self.validateUser(usr.email!, goto: controller)
              }
            }
          }
        }
        
      }
    }
  
  func handleMailLogin(login: String, password: String, in controller: UIViewController) {
    
    firebaseService.database.child("users").queryOrdered(byChild: "email").queryEqual(toValue: "\(login)")
    .observe(.value) { (snapshot) in
      
      if snapshot.value is NSNull {
        print("not found)")
        UserAlert.show(title: "This user does not exists", message: "please register", controller: controller)
      } else {
        self.firebaseService.signIn(email: login, password: password, in: controller)
        self.validateUser(login, goto: controller)
      }
    }
    
  }
  
  func validateUser(_ userId: String, goto controller: UIViewController) {
    UserDefaults.standard.set(userId, forKey: "currentUser")
   
    controller.present(self.mainVc, animated: true)
  }
  
  static func resetPassword(for email: String, in controller: UIViewController) {
    Auth.auth().sendPasswordReset(withEmail: email) { error in
       UserAlert.show(title: "Sorry", message: error!.localizedDescription, controller: controller)
    }
  }
}
