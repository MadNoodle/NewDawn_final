//
//  ObjectiveViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 19/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

class ObjectiveViewController: UIViewController,ChallengeControllerDelegate {
  let data = Category.getCategories()
  let reuseId = "my cell"
  var categoryTitle: ChallengeType?

  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UINib(nibName: "ObjectiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
    collectionView.reloadData()
  }
  
  func sendCategory() -> ChallengeType? {
    return categoryTitle
  }
  
}

extension ObjectiveViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? ObjectiveCollectionViewCell
    let currentObjective = data[indexPath.row]
    cell?.label.text = currentObjective.title.rawValue
    cell?.thumbnail.image = UIImage(named: currentObjective.imageName)
    return cell!
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    return CGSize(width: self.view.frame.width, height: 130.0)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    categoryTitle = data[indexPath.row].title
    
    let challengeVc = ChallengeController(nibName:nil, bundle: nil)
    challengeVc.delegate = self
    self.navigationController?.pushViewController(challengeVc, animated: true)
    
  }
}


