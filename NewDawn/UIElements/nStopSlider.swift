//
//  nStopSlider.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 14/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//

import UIKit


class NStopSlider: UISlider {
  
  @IBInspectable var thumbImage:UIImage? {
    didSet {
      setThumbImage(#imageLiteral(resourceName: "Knob"), for: .normal)
    }
  }
  
  override func draw(_ rect: CGRect) {
    self.tintColor = ColorTemplate.neutralGreen
  }

}
