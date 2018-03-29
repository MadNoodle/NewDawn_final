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
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    statusBar.backgroundColor = UIConfig.lightGreen
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
    
    let objectiveVc = MyChallengesViewController()
    
    let medicVc = MedicViewController()
    
    // Assign controllers to tab bar
    viewControllers = [
      createTabBarItem(LocalisationString.profilVcTitle, imageName: UIConfig.profilIcon, for: profilVc),
      createTabBarItem(LocalisationString.challengesVcTitle, imageName: UIConfig.challengesIcon, for: objectiveVc),
      createTabBarItem(LocalisationString.crisisVcTitle, imageName: UIConfig.crisisIcon, for: crisisVc),
      createTabBarItem(LocalisationString.historyVcTitle, imageName: UIConfig.historyIcon, for: historyVc),
      createTabBarItem(LocalisationString.medicVcTitle, imageName: UIConfig.medicIcon, for: medicVc)
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
