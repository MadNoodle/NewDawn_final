//
//  CrisisViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 18/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit

class CrisisViewController: UIViewController {
  var circles = [CAShapeLayer]()
  
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var pulsatingCircles: PulsatingCircles!
  
  @IBAction func animation(_ sender: UIButton) {
    pulsatingCircles.performAnimation()
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    startButton.layer.borderColor = UIColor.white.cgColor
    startButton.layer.borderWidth = 2.0
    startButton.layer.cornerRadius = 12.0
    pulsatingCircles.isHidden = true

    }
}
