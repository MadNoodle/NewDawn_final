//
//  CustomButton.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 16/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
import UIKit

/// Custom button than can change image when selected
class CustomUIButtonForUIToolbar: UIButton,SwitchableImage {
 
  @IBInspectable var imageName: String = ""
  /// Sets the button state. if the button has alrready been selected
  var choosen: Bool = false
 
  /// This method changes the button image when user clicks
  func userDidSelect() {
    if choosen {
      self.setImage(UIImage(named:imageName), for: .normal)
      choosen = false
    } else {
      self.setImage(UIImage(named:"\(imageName)_green"), for: .normal)
      choosen = true
    }
  }
  
  /// Self Explanatory
  func resetImage(){
    self.choosen = false
    self.setImage(UIImage(named:imageName), for: .normal)
    
  }

}
