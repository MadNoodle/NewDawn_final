///**
/**
 NewDawn
 Created by: Mathieu Janneau on 30/03/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace
import UIKit

class DateLauncher: NSObject {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  var selectedDate: String = ""
  
  // ///////////// //
  // MARK: - VIEWS //
  // ///////////// //
  
  let blackView = UIView()
  
  let container: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  let doneButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .white
    button.setTitle("Done", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  let datePicker : UIDatePicker = {
    let picker = UIDatePicker()
    picker.timeZone = NSTimeZone.local
    picker.backgroundColor = .white
    return picker
  }()
  
  // /////////////// //
  // MARK: - METHODS //
  // /////////////// //
  
  func showSettings() {
    //show menu
    
    if let window = UIApplication.shared.keyWindow {
      let height: CGFloat = 200
      let yValue = window.frame.height - height
      
      // Add views
      insantiateViewIn(window)
      
      // initial State
      blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
      datePicker.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
      container.frame = datePicker.frame
      doneButton.frame = datePicker.frame
      blackView.frame = window.frame
      blackView.alpha = 0
      
      // animate to show the Picker
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        
        self.blackView.alpha = 1
        self.datePicker.frame = CGRect(x: 0, y: yValue, width: self.datePicker.frame.width, height: self.datePicker.frame.height)
        self.container.frame = CGRect(x: 0, y: yValue - 30, width: self.container.frame.width, height: self.container.frame.height)
        self.doneButton.frame = CGRect(x: self.container.frame.width - 100, y: yValue - 30, width: 100, height: 30)
      }, completion: nil)
    }
  }
  
  fileprivate func insantiateViewIn(_ window: UIWindow) {
    // add tap gesture to remove launcher when tap outside of frame
    blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
    
    // add UI items
    window.addSubview(blackView)
    window.addSubview(container)
    window.addSubview(datePicker)
    window.addSubview(doneButton)
    
    // add action to button to send data back in controller
    doneButton.addTarget(self, action: #selector(userDidSelectDate), for: .touchUpInside)
  }
  
  fileprivate func closePicker(_ window: UIWindow) {
    self.datePicker.frame = CGRect(x: 0, y: window.frame.height, width: self.datePicker.frame.width, height: self.datePicker.frame.height)
    self.container.frame = CGRect(x: 0, y: window.frame.height, width: self.container.frame.width, height: self.container.frame.height)
    self.doneButton.frame = CGRect(x: 0, y: window.frame.height, width: self.doneButton.frame.width, height: self.doneButton.frame.height)
  }
  
  // ///////////////// //
  // MARK: - SELECTORS //
  // ///////////////// //
  
  @objc func handleDismiss() {
    UIView.animate(withDuration: 0.5) {
      self.blackView.alpha = 0
      if let window = UIApplication.shared.keyWindow {
        self.closePicker(window)
      }
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
