//
//  CrisisViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 18/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace
import UIKit
import AVFoundation

class CrisisViewController: UIViewController {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  // UI properties
  
  var isActive = false
  
  // Timer Properties
  var timer = Timer()
  var duration: Float = 120.0
  var timeRemaining: Int = 0
  let systemSoundID: SystemSoundID = 1023
  
  // MARK: - OUTLETS
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var pulsatingCircles: PulsatingCirclesView!
  @IBOutlet weak var breathLabel: UILabel!
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet var timerOptionsButtons: [UIButton]!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Relax yourself"
    timeRemaining = Int(duration)
    setupLabel()
    setupButton()
 
  }

  // /////////////// //
  // MARK: - ACTIONS //
  // /////////////// //
  
  @IBAction func animation(_ sender: UIButton) {

    let numberOfCycles = duration / 12.0
    if isActive == false {
      isActive = true
      runTimer()
      pulsatingCircles.circlesAnimation(for: numberOfCycles)
    } else {
      isActive = false
      timer.invalidate()
      pulsatingCircles.resetCirclesAnimation()
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

  // ////////////////// //
  // MARK: - ANIMATIONS //
  // ////////////////// //
  
  @objc func updateTimerLabel() {
    // Run countdown
    if timeRemaining > 0 {
      timeRemaining -= 1
      let countMS = timeRemaining.secondsToMinutesSeconds()
      timerLabel.text = "\(countMS)"
      
    } else {
      // Signal the end of countDown
      AudioServicesPlaySystemSound (systemSoundID)
      timerLabel.text = "Congratulations"
      timer.invalidate()
    }
  }

}
