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
    
    setupTabBar()
    
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
    navController.navigationBar.isTranslucent = false
    navController.tabBarItem.title = title
    navController.navigationBar.topItem?.title = title
    setpMenuButton(controller)
    
    //Set icon
    navController.tabBarItem.image = UIImage(named: imageName)
    
    return navController
  }
  
  // MARK: - MENU BUTTON
  fileprivate func setpMenuButton(_ controller: UIViewController) {
    let firstBarItem = UIBarButtonItem(image: UIImage(named: "opt"),
                                       style: .plain, target: self,
                                       action: #selector(addTapped))
    firstBarItem.tintColor = UIColor.white
    controller.navigationItem.leftBarButtonItem = firstBarItem
  }
  
  @objc func addTapped() {
    print("test")
  }
  
}
