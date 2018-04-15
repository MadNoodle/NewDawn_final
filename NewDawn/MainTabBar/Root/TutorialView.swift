///**
/**
NewDawn
Created by: Mathieu Janneau on 13/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import UIKit

class TutorialView: NSObject {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  var selectedDate: String = ""
  
  // ///////////// //
  // MARK: - VIEWS //
  // ///////////// //
  
  let blackView = UIView()
  


  
  // /////////////// //
  // MARK: - METHODS //
  // /////////////// //
  
  func showSettings() {
    //show menu
    
    if let window = UIApplication.shared.keyWindow {
      // Add views
      insantiateViewIn(window)
      
      
      // initial State
      blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
      blackView.frame = window.frame
      blackView.alpha = 0
      
      // animate to show the Picker
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        
        self.blackView.alpha = 1
    
    })
  }
  }
  
  
  fileprivate func insantiateViewIn(_ window: UIWindow) {
    // add tap gesture to remove launcher when tap outside of frame
    blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
    
    // add UI items
    window.addSubview(blackView)
    let tutoLabel = UILabel()
    window.addSubview(tutoLabel)
    tutoLabel.text = "Tap + button to choose an objective"
    tutoLabel.frame = CGRect(x: blackView.frame.width - 208, y: 0, width: 200, height: 20)
    tutoLabel.textColor = .white
    
  
  }

  
  // ///////////////// //
  // MARK: - SELECTORS //
  // ///////////////// //
  
  @objc func handleDismiss() {
    UIView.animate(withDuration: 0.5) {
      self.blackView.alpha = 0
    }
  }
  
  @objc func userDidSelectDate() {

    
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
