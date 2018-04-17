//
//  CustomButton.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 16/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit
enum CustomUIButtonForUIToolbarStyle {
  case imageButton
  case textButton
}
/// Custom button than can change image when selected
class CustomUIButtonForUIToolbar: UIButton, SwitchableImage {

  @IBInspectable var imageName: String = ""
  /// Sets the button state. if the button has alrready been selected
  var choosen: Bool = false
  var typeOfButton: CustomUIButtonForUIToolbarStyle = .imageButton
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  /// This method changes the button image when user clicks
  func userDidSelect() {
    switch typeOfButton {
    case .imageButton:
      changeImage()
    case .textButton:
      changeText()
    }
    
  }
  
  /// Self Explanatory
  func reset() {
    switch typeOfButton {
    case .imageButton:
      self.choosen = false
      self.setImage(UIImage(named: imageName), for: .normal)
    case .textButton:
       self.choosen = false
      self.layer.borderColor = UIColor(white: 0.5, alpha: 1).cgColor
      self.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .normal)
      self.backgroundColor = .white
    }
    
  }
  
  fileprivate func changeImage() {
    if choosen {
      self.setImage(UIImage(named: imageName), for: .normal)
      choosen = false
    } else {
      self.setImage(UIImage(named: "\(imageName)_green"), for: .normal)
      choosen = true
    }
  }
  
  fileprivate func changeText() {
    if choosen {
      self.layer.borderColor = UIColor(white: 0.5, alpha: 1).cgColor
      self.setTitleColor(UIColor(white: 0.5, alpha: 1), for: .normal)
      self.backgroundColor = .white
      choosen = false
    } else {
      self.layer.borderColor = UIConfig.darkGreen.cgColor
      self.backgroundColor = UIConfig.darkGreen
      self.setTitleColor(.white, for: .normal)
      choosen = true
    }
    
  }
  
}
