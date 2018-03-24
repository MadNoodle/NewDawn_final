//
//  MainTabBarController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 18/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

/**
 This class handles the main tab bar inititailization and behaviours
 */
class MainTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.shared.statusBarStyle = .lightContent
    setupTabBar()
    setupSwipe()
  }
  
  /**
   Create programatically tab bar.
   */
  private func setupTabBar() {
    
    let profilVc = HomeViewController()
    
    let historyVc = HistoryViewController()
    
    let crisisVc = CrisisViewController()
    
    let objectiveVc = ObjectiveViewController()
    
    let medicVc = MedicViewController()
    
    // Assign controllers to tab bar
    viewControllers = [
      createTabBarItem("Profil", imageName: "Profil", for: profilVc),
      createTabBarItem("Challenges", imageName: "challenges", for: objectiveVc),
      createTabBarItem("Crisis", imageName: "crisis", for: crisisVc),
      createTabBarItem("History", imageName: "history", for: historyVc),
      createTabBarItem("Find a Medic", imageName: "oscult", for: medicVc)
    ]
  }
  
  /**
   This method initialize tabBar item and insert them in a navigationController
   */
func createTabBarItem(_ title: String, imageName: String, for controller: UIViewController) -> UINavigationController {
    /// Navigontion controller embedded in tabBar
    let navController = UINavigationController(rootViewController: controller)
    // Set title
    navController.tabBarItem.title = title
    navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navController.navigationBar.shadowImage = UIImage()
    navController.navigationBar.isTranslucent = true
    navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    
    setpMenuButton(controller)
    
    //Set icon
    navController.tabBarItem.image = UIImage(named: imageName)
 
    return navController
  }
  
  // MARK: - MENU BUTTON
  fileprivate func setpMenuButton(_ controller: UIViewController) {
    let firstBarItem = UIBarButtonItem(image: UIImage(named: "hamburger_icon"),
                                       style: .plain, target: self,
                                       action: #selector(addTapped))
    firstBarItem.tintColor = UIColor.white
    controller.navigationItem.leftBarButtonItem = firstBarItem
  }
  
  @objc func addTapped() {
    print("test")

  }
  /**
   Initialize left and rigth swipe gesture in order to swipe between tab bars items
   */
  private func setupSwipe() {
    
    /// Right swipe gesture instantiation
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
    swipeRight.direction = UISwipeGestureRecognizerDirection.right
    self.view.addGestureRecognizer(swipeRight)
    
    /// Left swipe gesture instantiation
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
    swipeLeft.direction = UISwipeGestureRecognizerDirection.left
    self.view.addGestureRecognizer(swipeLeft)}
  
  /**
   Callback function for swipe gesture
   */
  @objc func swiped(_ sender: UISwipeGestureRecognizer) {
    if sender.direction == UISwipeGestureRecognizerDirection.left {
      self.selectedIndex += 1
    } else if sender.direction == UISwipeGestureRecognizerDirection.right {
      self.selectedIndex -= 1
    }
  }
}
