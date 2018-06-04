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
 /// Property to store username
  var currentUser: String = ""
  

  // MARK: -- LIFECYLCE METHODS
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // load current user
    if let user = UserDefaults.standard.object(forKey: "currentUser") as? String {
      currentUser = user
    }
    setupTabBar()
    self.tabBar.isTranslucent = false
    
  }
  
  /**
   Create programatically tab bar.
   */
  private func setupTabBar() {
    
    // Instantiate controllers
    let profilVc = HomeViewController()
    let historyVc = HistoryViewController()
    let crisisVc = CrisisViewController()
    let objectiveVc = MyChallengesViewController()
    let medicVc = MedicViewController()
    
    // Assign controllers to tab bar
    viewControllers = [
      createTabBarItem(NSLocalizedString("profilVcTitle", comment: ""), imageName: UIConfig.profilIcon, for: profilVc),
      createTabBarItem(NSLocalizedString("challengesVcTitle", comment: ""), imageName: UIConfig.challengesIcon, for: objectiveVc),
      createTabBarItem(NSLocalizedString("crisisVcTitle", comment: ""), imageName: UIConfig.crisisIcon, for: crisisVc),
      createTabBarItem(NSLocalizedString("historyVcTitle", comment: ""), imageName: UIConfig.historyIcon, for: historyVc),
      createTabBarItem(NSLocalizedString("medicVcTitle", comment: ""), imageName: UIConfig.medicIcon, for: medicVc)
    ]
  }
  
  /**
   This method initialize tabBar item and insert them in a navigationController
   */
  func createTabBarItem(_ title: String,
                        imageName: String,
                        for controller: UIViewController) -> UINavigationController {
    /// Navigontion controller embedded in tabBar
    let navController = UINavigationController(rootViewController: controller)
    // Set title
    navController.navigationBar.isTranslucent = false
    navController.tabBarItem.title = title
    navController.navigationBar.topItem?.title = title
    setpMenuButton(controller)
    //Set icon
    navController.tabBarItem.image = UIImage(named: imageName)
    return navController
  }
  
  // MARK: - MENU BUTTON
  
  /// Add button to navigation controller nabvigation bar
  ///
  /// - Parameter controller: UIViewController
  fileprivate func setpMenuButton(_ controller: UIViewController) {
    // settings button
    let firstBarItem = UIBarButtonItem(image: UIImage(named: "opt"),
                                       style: .plain, target: self,
                                       action: #selector(addTapped))
    firstBarItem.tintColor = UIColor.white
    controller.navigationItem.leftBarButtonItem = firstBarItem
  }
  
  /// Call back selector for bnavigation bar button
  @objc func addTapped() {
    // present menu
    let settingsVc = SettingsViewController()
    present(settingsVc, animated: true)
  }
  
}
