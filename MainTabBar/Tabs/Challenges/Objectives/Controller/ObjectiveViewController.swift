//
//  ObjectiveViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 19/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

class ObjectiveViewController: UIViewController, ChallengeControllerDelegate {
  
  // ///////////////////////// //
  // MARK: - PROPERTIES        //
  // ///////////////////////// //
  let data = Category.getCategories()
  let reuseId = "my cell"
  var categoryTitle: String = ""

  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UINib(nibName: "ObjectiveCollectionViewCell", bundle: nil),
                            forCellWithReuseIdentifier: reuseId)
    collectionView.reloadData()
  }
  
  /// Challenge Controller Delegate conformance method
  ///
  /// - Returns: ChallengeType?
  func sendCategory() -> String {
    return categoryTitle
  }
  
}

extension ObjectiveViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? ObjectiveCollectionViewCell
    // load data
    let currentObjective = data[indexPath.row]
    //s et title
    cell?.label.text = currentObjective.title
    // sett image
    cell?.thumbnail.image = UIImage(named: currentObjective.imageName)
    return cell!
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // Set custom height
    return CGSize(width: self.view.frame.width, height: 130.0)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    categoryTitle = data[indexPath.row].title
    
    if categoryTitle == NSLocalizedString("Custom", comment: ""){
       // show custom challenge creation controller
      let customVc = CreateCustomChallengeViewController(nibName: nil, bundle: nil)
      customVc.objective = data[indexPath.row].title
      
      self.navigationController?.pushViewController(customVc, animated: true)
    } else {
      // show generic challenge creation controller
    let challengeVc = ChallengeController(nibName: nil, bundle: nil)
    challengeVc.delegate = self
      challengeVc.category = categoryTitle
     
    self.navigationController?.pushViewController(challengeVc, animated: true)
      
    }
    
  }
}
