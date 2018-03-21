//
//  CrisisViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 18/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit
import AVFoundation

class CrisisViewController: UIViewController {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  // UI properties
  var circles = [CAShapeLayer]()
  let radius: [CGFloat] = [150, 120, 90, 60, 36]
  var isActive = false
  
  // Timer Properties
  var timer = Timer()
  var duration: Float = 120.0
  var timeRemaining: Int = 0
  let systemSoundID: SystemSoundID = 1023
  
  // MARK: - OUTLETS
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var pulsatingCircles: UIView!
  @IBOutlet weak var breathLabel: UILabel!
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet var timerOptionsButtons: [UIButton]!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    timeRemaining = Int(duration)
    setupLabel()
    setupButton()
    addCircles()
  }
  
  // MARK: - ACTIONS
  
  @IBAction func animation(_ sender: UIButton) {
    
    let numberOfCycles = duration / 12.0
    if isActive == false {
      isActive = true
      runTimer()
      circlesAnimation(for: numberOfCycles)
    } else {
      isActive = false
      timer.invalidate()
      resetCirclesAnimation()
    }
  }
  @IBAction func setDuration(_ sender: UIButton) {
    guard let title = sender.titleLabel?.text  else { return }
    if  let time = Float(title) {
      duration = time * 60
      timeRemaining = Int(duration)
      let countMS = timeRemaining.secondsToMinutesSeconds()
      timerLabel.text = "\(countMS)"
    }
    
  }
  
  // //////////////// //
  // MARK: - UI SETUP //
  // //////////////// //
  
  func runTimer() {
    timer = Timer.scheduledTimer(
      timeInterval: 1.0,
      target: self,
      selector: #selector(CrisisViewController.updateTimerLabel),
      userInfo: nil,
      repeats: true)
  }
  
  
  fileprivate func setupButton() {
    startButton.layer.borderColor = UIColor.white.cgColor
    startButton.layer.borderWidth = 2.0
    startButton.layer.cornerRadius = startButton.bounds.width / 2
    for button in timerOptionsButtons {
      button.layer.borderColor = UIColor.white.cgColor
      button.layer.borderWidth = 1.0
      button.layer.cornerRadius = button.bounds.width / 2
    }
  }
  
  fileprivate func setupLabel() {
    breathLabel.layer.cornerRadius = breathLabel.frame.width / 2
    breathLabel.layer.masksToBounds = true
    breathLabel.text = "BREATH"
  }
  
  fileprivate func addCircles() {
    
    let newCenter = CGPoint(x: self.pulsatingCircles.bounds.width / 2, y: self.pulsatingCircles.bounds.height / 2)
    
    for rad in radius {
      let pulsatingCircle = CAShapeLayer()
      let circularPath = UIBezierPath(arcCenter: .zero,
                                      radius: rad,
                                      startAngle: 0,
                                      endAngle: CGFloat(2 * Float.pi),
                                      clockwise: true)
      pulsatingCircle.path = circularPath.cgPath
      pulsatingCircle.fillColor = UIColor(white: 1, alpha: 0.2).cgColor
      circles.append(pulsatingCircle)
    }
    
    for circle in circles {
      circle.position = newCenter
      circle.lineCap = kCALineCapRound
      self.pulsatingCircles.layer.addSublayer(circle)
    }
  }
  
  // MARK: - ANIMATIONS
  
  @objc func updateTimerLabel() {
    if timeRemaining > 0 {
      timeRemaining -= 1
      let countMS = timeRemaining.secondsToMinutesSeconds()
      timerLabel.text = "\(countMS)"
      
    } else {
      AudioServicesPlaySystemSound (systemSoundID)
      timerLabel.text = "Congratulations"
      timer.invalidate()
    }
  }
  
  fileprivate func circlesAnimation(for cycles: Float) {
    // initial position
    pulsatingCircles.transform = CGAffineTransform.init(scaleX: 0.36, y: 0.36)
    
    UIView.animateKeyframes(withDuration: 12.0, delay: 0, options: [ .calculationModeCubicPaced], animations: {
      //repeat
      UIView.setAnimationRepeatCount(Float(cycles))
      
      // step number 1
      UIView.addKeyframe(withRelativeStartTime: 0.0/12.0, relativeDuration: 4.0/12.0, animations: {
        self.pulsatingCircles.transform = CGAffineTransform.identity
      })
      
      // step number 2
      UIView.addKeyframe(withRelativeStartTime: 5.0/12.0, relativeDuration: 7.0/12.0, animations: {
        self.pulsatingCircles.transform = CGAffineTransform.init(scaleX: 0.36, y: 0.36)
      })
    })
  }
  
  fileprivate func resetCirclesAnimation() {
    UIView.animate(withDuration: 2, animations: {
      self.pulsatingCircles.transform = CGAffineTransform.identity
    })
  }
}
