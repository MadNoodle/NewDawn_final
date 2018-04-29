//
//  AppDelegate.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace
import UIKit
import CoreData
import UserNotifications
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    handleFirebaseInitialization()
    handleUISetup()
    // initialize Notification
    NotificationService.setupNotificationCenter()
    NotificationService.center.delegate = self
    UserDefaults.standard.set("admin", forKey: "currentUser")
    return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    return handled
  }
  
  
  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {

  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate.
    //See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
      
      print("saved")
    }
    
    self.saveContext()
  }

  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {

      let container = NSPersistentContainer(name: "NewDawn")
      container.loadPersistentStores(completionHandler: { (_, error) in
          if let error = error as NSError? {

              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {

              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }
  
  fileprivate func navigationBarSetup() {
    // remove the 1 px shadow under navigationBar
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    UINavigationBar.appearance().barTintColor = UIConfig.lightGreen
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
  }
  
  fileprivate func statusBarSetup() {
    if let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView {
      statusBar.backgroundColor = UIConfig.lightGreen
      statusBar.isOpaque = true
      
    }
    
    UIApplication.shared.statusBarStyle = .lightContent
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              
                              willPresent notification: UNNotification,
                              
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler( [.alert, .badge, .sound])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
  
  fileprivate func handleUISetup() {
    // Set the first view controller to appear
    window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = LoginViewController()
    window!.makeKeyAndVisible()
    // Globally set Navigation and status bar scheme
    statusBarSetup()
    navigationBarSetup()
    // Globally set tabBar Seleccted color
    UITabBar.appearance().tintColor = UIConfig.lightGreen
  }
  
  fileprivate func handleFirebaseInitialization() {
    // initialize firebase
    FirebaseApp.configure()
    // initialize Firebase offline persistence
    Database.database().isPersistenceEnabled = true
    let userRef = Database.database().reference(withPath: "users")
    userRef.keepSynced(true)
    let moodRef = Database.database().reference(withPath: "moods")
    moodRef.keepSynced(true)
    let challengeRef = Database.database().reference(withPath: "challenges")
    challengeRef.keepSynced(true)
    // iniatlize twitter Login
    TWTRTwitter.sharedInstance().start(withConsumerKey:"onGHxAuY5Sctf1gbt3Wo1GZLg", consumerSecret:"9E7pl4JWwi8ZOhcJPCrV2oBozDK96REvrp8fsyQfiP9kYvA1VO")
  }
  
}
