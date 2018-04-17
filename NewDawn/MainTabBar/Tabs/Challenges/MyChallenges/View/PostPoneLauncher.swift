///**
/**
 NewDawn
 Created by: Mathieu Janneau on 05/04/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit

class PostPoneLauncher: NSObject {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  var selectedDate: String = ""
  
  // ///////////// //
  // MARK: - VIEWS //
  // ///////////// //
  
  let blackView = UIView()
  
  let container: UIView = {
    let stack = UIView()
    stack.backgroundColor = .white
    return stack
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Choose a new date"
    label.font = UIFont(name: UIConfig.lightFont, size: 24)
    label.textAlignment = .center
    return label
  }()
  
  let divider: UIView = {
    let divider = UIView()
    divider.backgroundColor = UIConfig.lightGreen
    return divider
  }()
  
  let datePicker: UIDatePicker = {
    let picker = UIDatePicker()
    return picker
  }()
  
  let button: GradientButton = {
    let button = GradientButton()
    return button
  }()
  
  // /////////////// //
  // MARK: - METHODS //
  // /////////////// //
  
  func showSettings() {
    //show menu
    
    if let window = UIApplication.shared.keyWindow {
      
      // Add views
      instantiateViews(window)
      
      // initial State
      
      button.setTitle("validate new date for challenge", for: .normal)
      button.titleLabel?.font = UIFont(name: UIConfig.lightFont, size: 16)
      
      blackView.frame = window.frame
      blackView.alpha = 0
      self.container.alpha = 0
      
      // animate to show the Picker
      UIView.animate(withDuration: 0.5,
                     delay: 0,
                     usingSpringWithDamping: 1,
                     initialSpringVelocity: 1,
                     options: .curveEaseOut,
                     animations: {
        
        self.blackView.alpha = 1
        self.container.alpha = 1
      }, completion: nil)
    }
    
  }
  
  func instantiateViews(_ window: UIWindow) {
    blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
    blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    
    window.addSubview(blackView)
    window.addSubview(container)
    window.addSubview(titleLabel)
    window.addSubview(divider)
    window.addSubview(datePicker)
    window.addSubview(button)
    button.addTarget(self, action: #selector(changeDate), for: .touchUpInside)
    // SETTINGS
    
    container.layer.cornerRadius = 10.0
    container.layer.masksToBounds = true
    
    // FRAMES
    let newOrigin: CGPoint = CGPoint(x: window.frame.width / 6, y: window.frame.height / 3)
    container.frame = CGRect(x: window.frame.width / 6,
                             y: window.frame.height / 3,
                             width: window.frame.width / 1.5,
                             height: window.frame.height / 2.5)
    titleLabel.frame = CGRect(x: newOrigin.x,
                              y: newOrigin.y + 16.0,
                              width: self.container.frame.width,
                              height: 30)
    divider.frame = CGRect(x: newOrigin.x + (self.container.frame.width / 2) - 55,
                           y: newOrigin.y + 55,
                           width: 110,
                           height: 1)
    datePicker.frame = CGRect(x: newOrigin.x + 16,
                              y: newOrigin.y + 32 + self.titleLabel.frame.height,
                              width: self.titleLabel.frame.width - 32,
                              height: 150)
    
    button.frame = CGRect(x: newOrigin.x + 32,
                          y: newOrigin.y + self.container.frame.height - 66,
                          width: self.container.frame.width - 64,
                          height: 50 )
  }
  
  // ///////////////// //
  // MARK: - SELECTORS //
  // ///////////////// //
  
  @objc func changeDate() {
    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "DateValueChanged"), object: nil, userInfo: ["Key": "key", "Date": datePicker.date]))
    print("button tapped")
    handleDismiss()
  }
  
  @objc func handleDismiss() {
    print("boom")
    UIView.animate(withDuration: 0.5) {
      self.blackView.alpha = 0
      self.container.alpha = 0
      self.container.removeFromSuperview()
      self.titleLabel.removeFromSuperview()
      self.divider.removeFromSuperview()
      self.datePicker.removeFromSuperview()
      self.button.removeFromSuperview()
      
    }
  }
  
  @objc func userDidSelectDate() {
    
    // send data back to controller
    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ValueChanged"), object: nil, userInfo: ["Key": "key", "Date": datePicker.date]))
    
    handleDismiss()
    print("Done")
    
  }
  
  // //////////// //
  // MARK: - INIT //
  // //////////// //
  
  override init() {
    super.init()
    
  }
}
