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


class LoginService {
  enum Source {
    case email
    case facebook
    case twitter
    
    static func connect( with provider: Source, in controller: UIViewController, infos: (String, String)?) {
      switch provider {
      case .email:
        guard let connectors = infos else {return}
        LoginService.handleMailLogin(login: connectors.0, password: connectors.1, in: controller)
        
      case .facebook:
        LoginService.handleFBLogin(in: controller)
      case .twitter:
        LoginService.handleTwitterLogin(in: controller)
      }
    }
  }
  static let firebaseService = FirebaseService()
  static let mainVc = MainTabBarController()
  
  static func handleTwitterLogin(in controller: UIViewController) {
    
    TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
      if session != nil {
        guard let authToken = session?.authToken, let authTokenSecret = session?.authTokenSecret else { return}
        
        let credential = TwitterAuthProvider.credential(withToken: authToken, secret: authTokenSecret)
        
        Auth.auth().signIn(with: credential) { (user, error) in
          if let error = error {
            UserAlert.show(title: "Sorry", message: error.localizedDescription, controller: controller)
            return
          }
          if let u = user {
            firebaseService.database.queryOrdered(byChild: "email").queryEqual(toValue: "\(u.uid)")
              .observe(.value) { (snapshot) in
                
                if ( snapshot.value is NSNull ) {
                  print("not found)")
                  firebaseService.saveInfo(user: u, username: u.uid, password: u.uid)
                  validateUser(u.uid, goto: controller)
                } else {
                  
                  validateUser(u.uid, goto: controller)
                }
            }
           
          }
        }
        } else {
        UserAlert.show(title: "Sorry", message: (error?.localizedDescription)!, controller: controller)
      }
    })
  }
  
  static func handleFBLogin(in controller: UIViewController) {
    
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    fbLoginManager.logIn(withReadPermissions: ["email"], from: controller) { (result, error) -> Void in
      if (error == nil){
        let fbloginresult : FBSDKLoginManagerLoginResult = result!
        // if user cancel the login
        if (result?.isCancelled)!{
          return
        }
        if(fbloginresult.grantedPermissions.contains("email"))
        {
          let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
          Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
              UserAlert.show(title: "Sorry", message: error.localizedDescription, controller: controller)
              return
            }
            if let u = user {
              firebaseService.database.queryOrdered(byChild: "email").queryEqual(toValue: "\(u.email!)")
                .observe(.value) { (snapshot) in
                  
                  if ( snapshot.value is NSNull ) {
                    print("not found)")
                    firebaseService.saveInfo(user: u, username: u.email!, password: u.uid)
                     validateUser(u.email!, goto: controller)
                  } else {
                    
                    validateUser(u.email!, goto: controller)
                  }
              }
            
            }
            
          }
        }
        
      }
    }
  }
  static func handleMailLogin(login: String, password: String, in controller: UIViewController) {
    
    firebaseService.database.queryOrdered(byChild: "email").queryEqual(toValue: "\(login)")
    .observe(.value) { (snapshot) in
      
      if ( snapshot.value is NSNull ) {
        print("not found)")
        UserAlert.show(title: "This user does not exists", message: "please register", controller: controller)
      } else {
        firebaseService.signIn(email: login, password: password, in: controller)
        validateUser(login, goto: controller)
      }
    }
    
  }
  static func validateUser(_ userId: String, goto controller: UIViewController) {
    UserDefaults.standard.set(userId, forKey: "currentUser")
   
    controller.present(self.mainVc, animated: true)
  }
  
  static func resetPassword(for email: String, in controller: UIViewController) {
    Auth.auth().sendPasswordReset(withEmail: email) { error in
       UserAlert.show(title: "Sorry", message:error!.localizedDescription, controller: controller)
    }
  }
}
