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
  let cycleLength: Float = 12.0
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
    timeRemaining = Int(duration)
    setupLabel()
    setupButton()
 
  }

  // /////////////// //
  // MARK: - ACTIONS //
  // /////////////// //
  
  @IBAction func animation(_ sender: UIButton) {
    // Define the number of animation for the selected duration
    let numberOfCycles = duration / cycleLength
    // start Breathing sessions
    if isActive == false {
      isActive = true
      // start timer
      runTimer()
      // update button title
      startButton.setTitle("stop", for: .normal)
      // start animation
      pulsatingCircles.circlesAnimation(for: numberOfCycles)
    } else {
      // stop breathing session
      isActive = false
      // stop timer
      timer.invalidate()
      // reset button title
      startButton.setTitle("Start", for: .normal)
      // stop and reset animation
      pulsatingCircles.resetCirclesAnimation()
    }
  }

  @IBAction func setDuration(_ sender: UIButton) {
    // grab button title and convert it to duration in min/sec
    guard let title = sender.titleLabel?.text  else { return }
    if  let time = Float(title) {
      duration = time * 60
      timeRemaining = Int(duration)
      // Convert
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
